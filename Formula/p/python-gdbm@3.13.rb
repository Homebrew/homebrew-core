class PythonGdbmAT313 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.11/Python-3.13.11.tgz"
  sha256 "03cfedbe06ce21bc44ce09245e091a77f2fee9ec9be5c52069048a181300b202"
  license "Python-2.0"

  livecheck do
    formula "python@3.13"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "36b715e29d738e2491c856aaad8ea27811d7bd577a1728568c1451933754be5d"
    sha256 cellar: :any, arm64_sequoia: "0e3ec3b6299023acd71ee84a77468b2f8dca2256da140ca89349b96a7892e865"
    sha256 cellar: :any, arm64_sonoma:  "90d79fc32525f212e6f034177b7c7ba517e36d7c175bc44473772587525fc7e2"
    sha256 cellar: :any, sonoma:        "f8fa8d57f4e437fe9e5c088ee9a331c7133b193242d986094a3945e2c07db875"
    sha256               arm64_linux:   "faea631e15a85c7d872fb4c0552c2bf36b81f81ea4a7eae8ae9a6f1aa08fbd6a"
    sha256               x86_64_linux:  "ca4e4c18edc57e21ec4513f8bc3507e243f2ed15c0c6f448ba2f94c90a4c4378"
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
