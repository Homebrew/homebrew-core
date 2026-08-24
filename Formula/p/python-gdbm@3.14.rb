class PythonGdbmAT314 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.7/Python-3.14.7.tgz"
  sha256 "62859805f6fdf25e2bcbf3fa3217801e1996887ca33e6a2af80674bdfa2dbe07"
  license "Python-2.0"

  livecheck do
    formula "python@3.14"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cfa4a35b8185f6d6aac665c31d7d4443c9b70d1bfa069d67b62bfbc832f7b5b2"
    sha256 cellar: :any, arm64_sequoia: "a72d540d92a824a79c6880a3c42ec96c05698a156f359938b7b3824b5f9a3966"
    sha256 cellar: :any, arm64_sonoma:  "3d0ea0c6a3b7ee0f07abbc6b87c202a4874eab2e2f29f3e31047b5538a52216f"
    sha256 cellar: :any, sequoia:       "458877666f5a936477782ac095567d2309634acf0450fb2e4847931394ba6b7e"
    sha256 cellar: :any, sonoma:        "078a8697cbfe479ccf08a71b2f4c32919f1e6ddb7a399e3507502d7865796298"
    sha256               arm64_linux:   "104bd630593b62f3dcaf188ee4c3ef01c606f70ad6d5907a3ea3c3e81bd20d02"
    sha256               x86_64_linux:  "607c4def398790d015119e46d035f6e7f5ca1190e95734df503844c35735700f"
  end

  # https://devguide.python.org/versions/#versions
  deprecate! date: "2030-11-01", because: :deprecated_upstream
  disable! date: "2031-11-01", because: :deprecated_upstream

  depends_on "gdbm"
  depends_on "python@3.14"

  def python3
    "python3.14"
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
