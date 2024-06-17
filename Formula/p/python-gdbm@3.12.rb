class PythonGdbmAT312 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.4/Python-3.12.4.tgz"
  sha256 "01b3c1c082196f3b33168d344a9c85fb07bfe0e7ecfe77fee4443420d1ce2ad9"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "bf337187b921aa4dbab2323d791d69b670ee784506843b72dfea1b7377656a93"
    sha256 cellar: :any, arm64_ventura:  "9ed82b5f261b71068a0ea27270eace5c994e5973938d5d54733da440f3d19688"
    sha256 cellar: :any, arm64_monterey: "8004693765d4133de1a8159737bab410710c3a64b884d565d52160c176863c66"
    sha256 cellar: :any, sonoma:         "bd466817e6e51124fa54272c7f0eb4de872d3891ab7766e46d0ca83f8332e4a1"
    sha256 cellar: :any, ventura:        "b719ce9855d37d2052b2a5bddc7ce6ca5ed68a53c5c70aa87ed276576bcf3de5"
    sha256 cellar: :any, monterey:       "7e35a507883a90a67b4d305942abfbd80be5dc18571b2cfa5c609437585d7cd6"
    sha256               x86_64_linux:   "d8b549f4603cbe41e72e55a780119c1c9bda5036958458224d2da089d84bd3b0"
  end

  depends_on "gdbm"
  depends_on "python@3.12"

  def python3
    "python3.12"
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
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false, build_isolation: true),
                                              "--target=#{libexec}", "."
      rm_r libexec.glob("*.dist-info")
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
