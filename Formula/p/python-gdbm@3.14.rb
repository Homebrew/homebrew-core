class PythonGdbmAT314 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.5/Python-3.14.5.tgz"
  sha256 "9c22bfe9939a6c5418fc74b289a5f1cc41859ae82ac6b163016b5844bd0a86bc"
  license "Python-2.0"

  livecheck do
    formula "python@3.14"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cf49f66901e213fdf25ce56dfe662f9f33675ef49394ad249af7fa20a392b9f8"
    sha256 cellar: :any, arm64_sequoia: "853fed0807d3b90d109c7ba8343742c53bbd73e202975031cff80c0ebd902a0e"
    sha256 cellar: :any, arm64_sonoma:  "12f58903cbcf47f7420ba2023885b7eb59d682d2c941883586c573b12f42a3a2"
    sha256 cellar: :any, sequoia:       "dc238052db1ae479329d9be9d589c3811cb74c8226063c13d381c3c0f82510b1"
    sha256 cellar: :any, sonoma:        "511e111f0cc9d8def1b72cbcd1db817bef5b5aa31d9c74a9b9a09ac744968c1b"
    sha256               arm64_linux:   "92618372f2370c9b570d516573719e81ba008a3880901a26b07a8a400ed38c0d"
    sha256               x86_64_linux:  "0f8f044aa01ae183d89ec6e6c2ebb29c673b405e76f16a57273c32fd6af63fb8"
  end

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
      Formula["python@#{xy}"].opt_include/"python#{xy}"
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
      include-dirs = ["#{Formula["gdbm"].opt_include}", "#{python_include}/internal"]
      libraries = ["gdbm"]
      library-dirs = ["#{Formula["gdbm"].opt_lib}"]
    TOML

    (buildpath/"Modules/pyproject.toml").append_lines <<~TOML if OS.linux?
      [[tool.setuptools.ext-modules]]
      name = "_dbm"
      sources = ["_dbmmodule.c"]
      include-dirs = ["#{Formula["gdbm"].opt_include}", "#{python_include}/internal"]
      libraries = ["gdbm_compat"]
      library-dirs = ["#{Formula["gdbm"].opt_lib}"]
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
