class PythonGdbmAT313 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.13/Python-3.13.13.tgz"
  sha256 "f9cde7b0e2ec8165d7326e2a0f59ea2686ce9d0c617dbbb3d66a7e54d31b74b9"
  license "Python-2.0"
  revision 1

  livecheck do
    formula "python@3.13"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "600a6cf9fe54cf0da695b879ee6b562a90634278b3daa00265194c94ff9ed56a"
    sha256 cellar: :any, arm64_sequoia: "0d56c5a03e258dd0c7ae6eb5d4c8e25dee8499f6a864365f20147c7acba764a4"
    sha256 cellar: :any, arm64_sonoma:  "80332a3a29437ea963fea8b3d54638908844e312ef8d298626e15bc1f793a713"
    sha256 cellar: :any, sequoia:       "596e19ddf1ff096fb0e22082e9097840b4c26fad690fa524658bbba61758de73"
    sha256 cellar: :any, sonoma:        "d72f17324ca5d2f704015e2cc2e027e8055b7f1d2907f3ccf5736400f48fbbde"
    sha256               arm64_linux:   "7ebd901cd5081189243f7848d84a49ee3171059bd08e1089e78a98bfceb55ee0"
    sha256               x86_64_linux:  "a492987b9b89430a5c9c83564ef9eaf4c1a879f820c677f4db1a2a0e0a11ee95"
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
