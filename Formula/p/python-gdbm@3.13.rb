class PythonGdbmAT313 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.5/Python-3.13.5.tgz"
  sha256 "e6190f52699b534ee203d9f417bdbca05a92f23e35c19c691a50ed2942835385"
  license "Python-2.0"

  livecheck do
    formula "python@3.13"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_sequoia: "3a533fb801d80f0ab62e9851a58b1336f3bd73ec128b19c418f05ad6b9211b23"
    sha256 cellar: :any, arm64_sonoma:  "b430013a9e63c6d007e2cc36ff474b36406122287edbd40ff10dfdaff238770e"
    sha256 cellar: :any, arm64_ventura: "a73ce71b8cfd07fa5baff74ba1ec90871d330b07e17fb08257f3899ca6292778"
    sha256 cellar: :any, sonoma:        "eef6def9e087a3a8781eae05fb38556bb2e2163846e7561ffcb6cff6ce4853da"
    sha256 cellar: :any, ventura:       "162efcd2465bad4b09c4ae7f6f740fc3feb30a017c5a4e387d521ce2dcf4d6c7"
    sha256               arm64_linux:   "6674f9304969998f14ebb365a5ee4bc1abc70c9f9b2426222522ba9e225ace49"
    sha256               x86_64_linux:  "fd78c64e837b2c6810a68feb998eff353fa0b6bc1f447361f94d28f974f01870"
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

    cd "Modules" do
      (Pathname.pwd/"setup.py").write <<~PYTHON
        from setuptools import setup, Extension

        setup(name="gdbm",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_gdbm", ["_gdbmmodule.c"],
                          include_dirs=["#{Formula["gdbm"].opt_include}", "#{python_include}/internal"],
                          libraries=["gdbm"],
                          library_dirs=["#{Formula["gdbm"].opt_lib}"])
              ]
        )
      PYTHON
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false, build_isolation: true),
                                              "--target=#{libexec}", "."
      rm_r libexec.glob("*.dist-info")
    end
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
  end
end
