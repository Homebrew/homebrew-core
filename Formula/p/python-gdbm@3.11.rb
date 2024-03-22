class PythonGdbmAT311 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.8/Python-3.11.8.tgz"
  sha256 "d3019a613b9e8761d260d9ebe3bd4df63976de30464e5c0189566e1ae3f61889"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "f8287ffa342b92ea9ba18b206b4950c4bf5234b6f345259526295addaca8f086"
    sha256 cellar: :any, arm64_ventura:  "c2b069932884c09a82c9964c3da8743ae177fef989ebfc073d9cc655a144b2fd"
    sha256 cellar: :any, arm64_monterey: "94673d8cfd75ca1c184cb2ed0114eb4313f1c86012a21c21fe3a3c4b605b9f56"
    sha256 cellar: :any, sonoma:         "b3f2964243f0e2a0bc2cb57d3083cf75e754793ab4481dc7cb8c249dead8836f"
    sha256 cellar: :any, ventura:        "3aafc6e1fdd6ed30348cf563b2d541d83a0cc73ad592e4744f3db66d51bd55af"
    sha256 cellar: :any, monterey:       "37f7b4aa5d78cb775e9c0b43f51cb381ebe9afabde416665cfc514e9633bacb5"
    sha256               x86_64_linux:   "ced434dba60a180105b4a15efc3bcb67cf7d92c05839294642cb725e4b5b85c5"
  end

  depends_on "gdbm"
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    cd "Modules" do
      (Pathname.pwd/"setup.py").write <<~EOS
        from setuptools import setup, Extension

        setup(name="gdbm",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_gdbm", ["_gdbmmodule.c"],
                          include_dirs=["#{Formula["gdbm"].opt_include}"],
                          libraries=["gdbm"],
                          library_dirs=["#{Formula["gdbm"].opt_lib}"])
              ]
        )
      EOS
      system python3, *Language::Python.setup_install_args(libexec, python3),
                      "--install-lib=#{libexec}"
      rm_r libexec.glob("*.egg-info")
    end
  end

  test do
    testdb = testpath/"test.db"
    system python3, "-c", <<~EOS
      import dbm.gnu

      with dbm.gnu.open("#{testdb}", "n") as db:
        db["testkey"] = "testvalue"

      with dbm.gnu.open("#{testdb}", "r") as db:
        assert db["testkey"] == b"testvalue"
    EOS
  end
end
