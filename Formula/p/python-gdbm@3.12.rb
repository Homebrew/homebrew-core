class PythonGdbmAT312 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.11/Python-3.12.11.tgz"
  sha256 "7b8d59af8216044d2313de8120bfc2cc00a9bd2e542f15795e1d616c51faf3d6"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_sequoia: "e9dfb0a8a1c5c3d32e8a0e32f98acd0727a4c595baa9208b4ec248f1861b863a"
    sha256 cellar: :any, arm64_sonoma:  "6b52029d5aad2e4540c870d36b104464599d645bd7f6517fcca289247a147b3a"
    sha256 cellar: :any, arm64_ventura: "07c8cd8a2de571b010ce425c75ef0ef597c15a0ed09387aa998f3aba86ec69b8"
    sha256 cellar: :any, sonoma:        "2f052556d673a0d83e3b4cf2b06c2b45101368a333d68457772392774a014014"
    sha256 cellar: :any, ventura:       "eb2341ddebf93b1f6f1af614569b6ce7062ca179002dcb9803ebc1ad9f48e890"
    sha256               arm64_linux:   "927f8385c7a3b75caf36346b846dc92c78ecc12f6d7fab781abb58abdc08d04e"
    sha256               x86_64_linux:  "4762b9c183e68b62c595de5a62ad300250e7c8f4db069a31f9c543e13261d379"
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
