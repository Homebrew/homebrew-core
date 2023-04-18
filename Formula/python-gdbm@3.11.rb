class PythonGdbmAT311 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.3/Python-3.11.3.tgz"
  sha256 "1a79f3df32265d9e6625f1a0b31c28eb1594df911403d11f3320ee1da1b3e048"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "8767e40729ec26474f3835287629442d2f01556bdff89672ca57451c815f01d0"
    sha256 cellar: :any, arm64_monterey: "18f0e9ed512f72a4afa05d5ae286d2daec17701840387e35960e47b87551d4f4"
    sha256 cellar: :any, arm64_big_sur:  "9f97a9b301758e05a15b514a8e94561151f9d109465e45c557b72893e5f8057f"
    sha256 cellar: :any, ventura:        "e01cde39f639580713e63f4f6564d2bb9162211cbed267ae7880542c9ca153c6"
    sha256 cellar: :any, monterey:       "88e5a479e7881f9fc70978e8accc81fe4b3d3a4ea0685f353070bacfa6b18cf6"
    sha256 cellar: :any, big_sur:        "72adeb8019bceb93ba767910ba127c9cb8dfa19c99e051c7068078907ca59d94"
    sha256               x86_64_linux:   "ef55481beabf890ea48d81ec77996176183b7eab2d6d745589e3af38c91a96a1"
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
