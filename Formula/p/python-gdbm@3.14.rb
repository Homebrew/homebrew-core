class PythonGdbmAT314 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.0/Python-3.14.0.tgz"
  sha256 "88d2da4eed42fa9a5f42ff58a8bc8988881bd6c547e297e46682c2687638a851"
  license "Python-2.0"

  livecheck do
    formula "python@3.14"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8381106cc45125d87bbc5f1f40f984b3875b42b0281d37913f541d6f6335d7d8"
    sha256 cellar: :any, arm64_sequoia: "609ec5c041cab8d6ea4f46cca01272ddf3e1c307b09b0f3c3974cd1eb05e326f"
    sha256 cellar: :any, arm64_sonoma:  "a6499f73f34d8f346df65daa50da033a33583381795743599c4cb797c0816a81"
    sha256 cellar: :any, sonoma:        "dec0a6beebde2002d41e0a313dea1e428ed04eba37b21426ad9860dc92ae1f1f"
    sha256               arm64_linux:   "a26ddde4afa8c96a1fb3e00a7ff3e041992021fc043f189f56c07e90062e4b5d"
    sha256               x86_64_linux:  "4f19f6e8cbe5644b8201502069e8a43138fd9ad180115a5705b75cebb7bf33ea"
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
