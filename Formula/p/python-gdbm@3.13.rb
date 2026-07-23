class PythonGdbmAT313 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.14/Python-3.13.14.tgz"
  sha256 "5ae535a36af0ebca6fca176ecb8197f5db9c1cb8c8f0cd12cdf1787046db1f41"
  license "Python-2.0"

  livecheck do
    formula "python@3.13"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6db2382ff4f1eb6b00f42f6f1b48d8e9403ae573f7c3ecc96d11916e3591eef2"
    sha256 cellar: :any, arm64_sequoia: "7d388f39554679851cbf020277dc168cee99bd2c636a23ccdc8133c1544dbe1f"
    sha256 cellar: :any, arm64_sonoma:  "7f477868293f8f7cc211d233033ea30ed13fbdc0a37d913e375991e19c485b9c"
    sha256 cellar: :any, sequoia:       "fb87bb26b554b6500456d50b60807163d3bbd19b270cd20f91922ce5f7f716dd"
    sha256 cellar: :any, sonoma:        "5deff4281dfb6dbedda416c9d19a5eabc8113e898fe85a3478800e79c9f96554"
    sha256               arm64_linux:   "2d02436e1fd7c75d09db571d26e76aff1da60ac56eb9243b759bf2653df572ff"
    sha256               x86_64_linux:  "a1f8ca45ed161701ba3da652ec869f57c8e286957e17c95df5ee07e9f014a91c"
  end

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
