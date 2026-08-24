class PythonGdbmAT313 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.15/Python-3.13.15.tgz"
  sha256 "c28d9d213c09b5b5ab2c29812950e12f746999e099b82894231be954b26baed9"
  license "Python-2.0"

  livecheck do
    formula "python@3.13"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "08c8957a439aa18148e25bf288c9ae6fcc21164572bbd88e1bd2e0b1d1dae9b3"
    sha256 cellar: :any, arm64_sequoia: "43e9f099e64269efafa573690b2632c6a8a6feb1d9ebef660a5e690cf7c2863e"
    sha256 cellar: :any, arm64_sonoma:  "2505cbe2f5320745f16171e3f6af40b7fa3e599ad4bd1476a94e3e094db5b939"
    sha256 cellar: :any, sequoia:       "d7b284c6d15333f1ba1dfd0783100abebf0d34eaafab1e859d356266a334ec8e"
    sha256 cellar: :any, sonoma:        "880b031eaf1b2b4f6a0ec3aaab9d649a10f2394cd5af95d91dda4c8cfb6beb7d"
    sha256               arm64_linux:   "4e2d38ae9d6810db6f032b16bde104426e37ef55f16d131d47fa5ff15e1cc8b5"
    sha256               x86_64_linux:  "c73f432fcbd694ad00e6f3a24ca89487e35cc4559d19e03eea8e980bf078f350"
  end

  # https://devguide.python.org/versions/#versions
  deprecate! date: "2029-11-01", because: :deprecated_upstream
  disable! date: "2030-11-01", because: :deprecated_upstream

  depends_on "gdbm"
  depends_on "python@3.13"

  def python3
    "python3.13"
  end

  def install
    xy = Language::Python.major_minor_version python3
    python_include = if OS.mac?
      Formula["python@#{xy}"].opt_frameworks/"Python.framework/Versions/#{xy}/include/python#{xy}"
    else
      formula_opt_include("python@#{xy}")/"python#{xy}"
    end

    (buildpath/"Modules/pyproject.toml").write <<~TOML
      [project]
      name = "gdbm"
      version = "#{version}"
      description = "#{desc}"

      [tool.setuptools]
      packages = []

      [[tool.setuptools.ext-modules]]
      name = "_gdbm"
      sources = ["_gdbmmodule.c"]
      include-dirs = ["#{formula_opt_include("gdbm")}", "#{python_include}/internal"]
      libraries = ["gdbm"]
      library-dirs = ["#{formula_opt_lib("gdbm")}"]
    TOML

    (buildpath/"Modules/pyproject.toml").append_lines <<~TOML if OS.linux?
      [[tool.setuptools.ext-modules]]
      name = "_dbm"
      sources = ["_dbmmodule.c"]
      include-dirs = ["#{formula_opt_include("gdbm")}", "#{python_include}/internal"]
      libraries = ["gdbm_compat"]
      library-dirs = ["#{formula_opt_lib("gdbm")}"]
      extra-compile-args = ["-DUSE_GDBM_COMPAT", "-DHAVE_GDBM_DASH_NDBM_H"]
    TOML

    system python3, "-m", "pip", "install", *std_pip_args(prefix: false, build_isolation: true),
                                            "--target=#{libexec}", "./Modules"
    rm_r libexec.glob("*.dist-info")
  end

  test do
    testdb = testpath/"test.db"
    system python3, "-c", <<~PYTHON
      import dbm.gnu

      with dbm.gnu.open("#{testdb}", "n") as db:
        db["testkey"] = "testvalue"

      with dbm.gnu.open("#{testdb}", "r") as db:
        assert db["testkey"] == b"testvalue"
    PYTHON

    return unless OS.linux?

    (testpath/"dbm_test.py").write <<~PYTHON
      import dbm

      with dbm.ndbm.open("test", "c") as db:
        db[b"foo \\xbd"] = b"bar \\xbd"
      with dbm.ndbm.open("test", "r") as db:
        assert list(db.keys()) == [b"foo \\xbd"]
        assert b"foo \\xbd" in db
        assert db[b"foo \\xbd"] == b"bar \\xbd"
    PYTHON
    system python3, "dbm_test.py"
  end
end
