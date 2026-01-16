class PythonGdbmAT312 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.12/Python-3.12.12.tgz"
  sha256 "487c908ddf4097a1b9ba859f25fe46d22ccaabfb335880faac305ac62bffb79b"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "68ed9a1c7a748ca1d8607f33f021fbbe6d2ec0fb7d623dcf8c0787ae4d833faa"
    sha256 cellar: :any, arm64_sequoia: "74c09bb14030cc7696dad2824882577a27b215800d68c7ff815371babed645cb"
    sha256 cellar: :any, arm64_sonoma:  "21054c1db4cc70b382615b2be938b9a56551b33cb5d3d82c5f95e99ea9118800"
    sha256 cellar: :any, sonoma:        "071b93500396e9746c8d3567d8763a8446eb288e0b3b61aa5e9c8e897e44af9b"
    sha256               arm64_linux:   "33020fd29f43c0ff62d9f8c739761d748ad2e2fdc3651c7cb20f7bc5e51b5f23"
    sha256               x86_64_linux:  "fe17b63305c292568db10752614ff14042c37fd6a42b99d559ccb8a903876bf9"
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
