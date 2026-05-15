class PythonGdbmAT312 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.13/Python-3.12.13.tgz"
  sha256 "0816c4761c97ecdb3f50a3924de0a93fd78cb63ee8e6c04201ddfaedca500b0b"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0e5d91f359c8c637340ecba17b83a5fc4fdecf773ef100e3af4f2a0bd87ef2b8"
    sha256 cellar: :any, arm64_sequoia: "28301403f1c5249d19cb51e82c1edc35c36c54cfd171e1df53859de48cd9915a"
    sha256 cellar: :any, arm64_sonoma:  "679ecd75ce11fad8e4bbc46e47f77bd712e0cef54e357f5c13a0568c2937c6c7"
    sha256 cellar: :any, sonoma:        "ec513ca3af354f7753f4b75f50266ac0ee3f454c27a42f1e1244ce62cf25aab4"
    sha256               arm64_linux:   "301118405058ffc7144603b4a39099eeb0a3c379a2b564a040f912a5544aed08"
    sha256               x86_64_linux:  "4582c9437253e10e7195b441f7dd5677b58d75b7523ad361b805ec7c5e339a6c"
  end

  depends_on "gdbm"
  depends_on "python@3.12"

  def python3
    "python3.12"
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
