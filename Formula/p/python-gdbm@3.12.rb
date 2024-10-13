class PythonGdbmAT312 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.7/Python-3.12.7.tgz"
  sha256 "73ac8fe780227bf371add8373c3079f42a0dc62deff8d612cd15a618082ab623"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "63c5604dac90c9f5caeff9048a356974f264c23e19e71a1f00038cff94248dbd"
    sha256 cellar: :any, arm64_sonoma:  "0850ecb339f79f4b74b200a6707a74ae3c7a973100892b1e2c919dbeccce2664"
    sha256 cellar: :any, arm64_ventura: "ecd7fec78dc938ec4d58dda6c031e89ab99d4f77e71790d96889f38f2c05a262"
    sha256 cellar: :any, sonoma:        "55f70d3c5a89b8de7c6452b521ea8645cf1cd3b002e2f6a8ce6cae9326550a48"
    sha256 cellar: :any, ventura:       "44ab8aefa06d2af77193f2b399e782e0ae8917002d4e9393f316f2e228bf24d0"
    sha256               x86_64_linux:  "9fb06a5c4094750bef26395bd2131b90f5e9e46d2a74bad6862fb29205fa5801"
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
