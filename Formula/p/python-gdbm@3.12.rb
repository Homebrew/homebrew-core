class PythonGdbmAT312 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.13/Python-3.12.13.tgz"
  sha256 "0816c4761c97ecdb3f50a3924de0a93fd78cb63ee8e6c04201ddfaedca500b0b"
  license "Python-2.0"
  revision 1

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "803fc4ada419af2b97f6c0c1d882d61539baa909300e32928cdd21b92c201d71"
    sha256 cellar: :any, arm64_sequoia: "d1a5df2a33ac7b9116cbcc42bfe67038b4ae9911b17c7c443f9b48bd7b8249e5"
    sha256 cellar: :any, arm64_sonoma:  "043613576d5a8ecd144ca7c15c93938c4ee65a085def9a283637e96dee9ccce5"
    sha256 cellar: :any, sequoia:       "3018def7f26a0960ac3509c216868b9fae2122fd6ce5f740b7f1d7a68878975b"
    sha256 cellar: :any, sonoma:        "b8af79c9443ddc4582c19b31e2b53b731675c07b7b15ebfeeb85dbe046ed5968"
    sha256               arm64_linux:   "9afbae2122292edf3140384b2e4d1b4bb6ab66848a858a0448c6755f91455eb4"
    sha256               x86_64_linux:  "800645a6b8b6fc2f2988706739aa142d89930bd7c0d9e662e6f2cbfc60d0547f"
  end

  depends_on "gdbm"
  depends_on "python@3.12"

  def python3
    "python3.12"
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
