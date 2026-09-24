class PythonGdbmAT315 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.15.0/Python-3.15.0rc2.tgz"
  sha256 "164dbb80f5e1fdd8768387724bfa014da1000401b2015d872a2396c8b858b829"
  license "Python-2.0"

  livecheck do
    formula "python@3.15"
  end

  # https://devguide.python.org/versions/#versions
  deprecate! date: "2030-11-01", because: :deprecated_upstream
  disable! date: "2031-11-01", because: :deprecated_upstream

  depends_on "gdbm"
  depends_on "python@3.15"

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
