class PythonGdbmAT311 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.9/Python-3.11.9.tgz"
  sha256 "e7de3240a8bc2b1e1ba5c81bf943f06861ff494b69fda990ce2722a504c6153d"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "92590819090deb61bdda7ca23173512ac77f5fa5b5e1240c7c3a93de9300829a"
    sha256 cellar: :any, arm64_ventura:  "a61682024985978be65818bdd9661682a275e2b5217bc9d06de9a818e5480a6d"
    sha256 cellar: :any, arm64_monterey: "346d13c449c626cfb77cc32c3aa63fce057e48516b77ca3d05ff515702b34883"
    sha256 cellar: :any, sonoma:         "d3b5fdcc91026f4c8c31a40d0d6002be66b790cad56e922cf16d3dd70c91caa9"
    sha256 cellar: :any, ventura:        "39197fb685019fdfb12edf7c4174ca82e0427369178b3df02cb5b9c25b978a2f"
    sha256 cellar: :any, monterey:       "8594347dd3fa4a50591798ac797aa72e85a7fc624eaf5b336993487d48ad8e95"
    sha256               x86_64_linux:   "1d396e5eec9f29dc2d84193d2309e86e4bec48c37dbc52a8644c1f108d34bc15"
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
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false), "--target=#{libexec}", "."
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
