class PythonGdbmAT315 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.15.2/Python-3.15.2.tgz"
  sha256 "f74e1db0eabd651cd01e4e2a00201bd41866abe74869ab716f9bf33cbbaa0943"
  license "Python-2.0"

  livecheck do
    formula "python@3.15"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c1d57091cdba6cf08298905625dac6a47a20a98546695abeb45eff2c1e6d0e12"
    sha256 cellar: :any, arm64_tahoe:       "ab509b7b1ca0bcfbcdf17e16ad816c7a37a1442d2d2a2d9e78e81eb8ac7408cc"
    sha256 cellar: :any, arm64_sequoia:     "5f84e4014dd9ec83803d825cfae07dca84074e74c0a599eefa83d2c129c41cf9"
    sha256               arm64_linux:       "2818da31eb9fccf16a388dc0cab6c214797dd1eb679c2ca2d5ea65de054f24d5"
    sha256               x86_64_linux:      "c01488822bf5a74a580b1291832467b9f056e51a88f5d6d1a9db40623d386ac1"
  end

  # https://devguide.python.org/versions/#versions
  deprecate! date: "2031-11-01", because: :deprecated_upstream
  disable! date: "2032-11-01", because: :deprecated_upstream

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
