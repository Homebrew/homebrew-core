class PythonGdbmAT312 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.10/Python-3.12.10.tgz"
  sha256 "15d9c623abfd2165fe816ea1fb385d6ed8cf3c664661ab357f1782e3036a6dac"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "d1c8217aca34078b11bcc486dd24b4fb9b73c3e40e458eb80e2f7dd48bbd7a8c"
    sha256 cellar: :any, arm64_sonoma:  "2235422e60703d43bb908b61d668bd32ac41258e46b0927f37a015b0829de3f3"
    sha256 cellar: :any, arm64_ventura: "ec356282e7e466619e82265b82ea1a75abbb7ad95548ec4e795a188eea16e0dd"
    sha256 cellar: :any, sonoma:        "18d9ba31b571e6365849f5f0c8c0a9fd541eac65b6535a12d8629bb30fe10cbf"
    sha256 cellar: :any, ventura:       "8d04a7b48ed2f2cac5a3016cbe4fd76379cb691a5daf0ccf053f8828059b9705"
    sha256               arm64_linux:   "d33b60d7a05278e3417edbb677d27284ef618c8913d094e8b770d42681425d3d"
    sha256               x86_64_linux:  "1ba9cff9e3e6bf6095e92e04ac84db78a2a88bbf112e0a5bc196e569ea3e2f4b"
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
