class PythonGdbmAT313 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.0/Python-3.13.0.tgz"
  sha256 "12445c7b3db3126c41190bfdc1c8239c39c719404e844babbd015a1bc3fafcd4"
  license "Python-2.0"

  livecheck do
    formula "python@3.13"
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "b093d82ca81a7f3c90d04c9b49d03b01d95676ed606df10f028ad42455515fd0"
    sha256 cellar: :any, arm64_sonoma:  "bdd770b601deaa2279e1083e175bfaa1802717f664ccf9a71af3eda030f93917"
    sha256 cellar: :any, arm64_ventura: "ab2294f45ddf0aef4a0c0de3f4d1e860bf94af73f3bbbfc0e665e17526f27bc9"
    sha256 cellar: :any, sonoma:        "b5e0bc3be258ee0d73f6859a9d5ad154abad49f958c8379addbc6b99a170a1f6"
    sha256 cellar: :any, ventura:       "a3ddfe201816343a8c32c4cf59c4a083abd952f374a20f7c08b49f36dd8d4620"
    sha256               x86_64_linux:  "5df8fcb2293ddbc40817ca11176b469a23b3f0f40f5b65a99bd15f38ed6d829f"
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
      (Pathname.pwd/"setup.py").write <<~EOS
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
