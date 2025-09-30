class PythonGdbmAT313 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.7/Python-3.13.7.tgz"
  sha256 "6c9d80839cfa20024f34d9a6dd31ae2a9cd97ff5e980e969209746037a5153b2"
  license "Python-2.0"

  livecheck do
    formula "python@3.13"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "62e4d0f2d482abb53735eaeafaa697ac3a1275ad0c01c9a394312c624e4a5ee4"
    sha256 cellar: :any, arm64_sequoia: "17d36e5597707a8f1fb54a8675919f502ed4bd851cb8a52fec00645b84332ffa"
    sha256 cellar: :any, arm64_sonoma:  "a29c5e9f5360f2118789880baff30fa62730bddb5852d49b96faaa0303f52457"
    sha256 cellar: :any, arm64_ventura: "7e66785ac8c3f51dee5194a56bfa2386ea918a8c694fcc21da64446a7650e462"
    sha256 cellar: :any, sonoma:        "15d2040b23218a0dabf65e44fde43962a1687451c78164885675f5cb27a88157"
    sha256 cellar: :any, ventura:       "64bde23f63fe042b2f84fa0072913aa8d99c3d8e26de018dbe75c3159cbcfbdb"
    sha256               arm64_linux:   "34a9c0f028a0e61899afc06f62dd75a59c9e4caf18e211856f6d2c8cd6b68f7d"
    sha256               x86_64_linux:  "c266e7df3ee40673c8b96c3f033f4d76b830e3752ff34d79d82e9f06e031d5aa"
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
