class PythonGdbmAT311 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.4/Python-3.11.4.tgz"
  sha256 "85c37a265e5c9dd9f75b35f954e31fbfc10383162417285e30ad25cc073a0d63"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "cd3c8cab66cc6b498cfaaa36a287928cf6b1750f21e9b8709348b7d5fa6265c6"
    sha256 cellar: :any, arm64_monterey: "efea710a7077d6fb6ebdc4db37579d864b3a3b91e85e3e7241524a1c019561d6"
    sha256 cellar: :any, arm64_big_sur:  "21e200dc93934debef789bc03272611dcc46bbbf150aea9633b263915dc6e16c"
    sha256 cellar: :any, ventura:        "8fac5348dce6939beb81f558a635400d35bc24d6e02678c42dd01a88ebfe8bcd"
    sha256 cellar: :any, monterey:       "e0a9334176f13e41a20b644f14746f400a30fa7ac3ed1b3ecba3b2104321ddcd"
    sha256 cellar: :any, big_sur:        "4b5793d4fadb235a3de4b3bd78d3ce3569c2760ccceb218730aab0c3c727ce0b"
    sha256               x86_64_linux:   "4f744ab9025676bf5200efa1dab888efa8cc994288285591c1eca17d77546168"
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
