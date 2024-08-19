class PythonGdbmAT312 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.5/Python-3.12.5.tgz"
  sha256 "38dc4e2c261d49c661196066edbfb70fdb16be4a79cc8220c224dfeb5636d405"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "c1c9969544e3ecc3c60311a284f2230bd79b04c4afcd6d60fb74a2bdbac76f52"
    sha256 cellar: :any, arm64_ventura:  "205fa55f400655a53e7f8a0cfcc33ce69243fa7760468ebefe9cc0b7986556ff"
    sha256 cellar: :any, arm64_monterey: "efcb3a411ca35f8d978e957cc1f327a47db61403779ddca87fa4890499649624"
    sha256 cellar: :any, sonoma:         "1397047586e618a2d56e478e5d0cd7f4bee09eff87d5419247b2bc347b6d334d"
    sha256 cellar: :any, ventura:        "4e65c81ed7f9db642835d47670756c77d82daa4bb2597af1ac0491fff0b551bd"
    sha256 cellar: :any, monterey:       "a1ddf6c2346b0026fad2f0a45a312537203003c4fe2c35ce58d9ed2f5febcd7e"
    sha256               x86_64_linux:   "f68281e90c251b555a79aaba90769c8e2050d65171a1d01b1dbe3f6ad507070c"
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
