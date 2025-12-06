class PythonGdbmAT314 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.2/Python-3.14.2.tgz"
  sha256 "c609e078adab90e2c6bacb6afafacd5eaf60cd94cf670f1e159565725fcd448d"
  license "Python-2.0"

  livecheck do
    formula "python@3.14"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "2e62fc086f556403dcfc82d1d27c0323f2df7217d8baf4d32d27f7f2bde69f42"
    sha256 cellar: :any, arm64_sequoia: "82cdc6e3c2986cf0d8633b063e20ea6c9f23c2b17abfda685381662aac04d442"
    sha256 cellar: :any, arm64_sonoma:  "0ba934d59277a62f0cf816903b84906933bf067f18c8a384dbc4b8852bd54dc1"
    sha256 cellar: :any, sonoma:        "ec2f8373b4158a8f63c5bcae4f5c782b3bade58f7ca4f1b7224b5363929b86e3"
    sha256               arm64_linux:   "7ceaadee2476a3ccfe28ea5d5aca480a81fcae1cb502e5a2ea7d946d68d1c397"
    sha256               x86_64_linux:  "fccf8d261d223b3b061d043a9235f8980dc5b76d604f3adf28fe3496bd4f16f4"
  end

  depends_on "gdbm"
  depends_on "python@3.14"

  def python3
    "python3.14"
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
