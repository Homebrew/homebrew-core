class PythonGdbmAT313 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.3/Python-3.13.3.tgz"
  sha256 "988d735a6d33568cbaff1384a65cb22a1fb18a9ecb73d43ef868000193ce23ed"
  license "Python-2.0"

  livecheck do
    formula "python@3.13"
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "e159fc9a3a64443c8aff10846b32551521a1526ae21a65713593569b6d4e01e4"
    sha256 cellar: :any, arm64_sonoma:  "f697ae9ed3f4e57c603fcf21a03a0ea9a0c55379f0db6cf993a824b69c9d7cd6"
    sha256 cellar: :any, arm64_ventura: "9e52c8f2f96f48f922f28f4a32cdcf4474ca1dd245b6d8d2fe2f9d9c548e795c"
    sha256 cellar: :any, sonoma:        "ed6f0255cf007af4739a547399ebfb5f061dab02ebf78e6753db42ba1369495f"
    sha256 cellar: :any, ventura:       "89dfc33ead9e4287511aaa1db652b0019df7c3e294c500ea4b70caa3cccc7ffb"
    sha256               arm64_linux:   "afa2912ff94b2e0c7d5dd7b769d9d7622dbb6dea51f6efdf91d0b9868dc43175"
    sha256               x86_64_linux:  "96a755eb5a2dc3426127d0ba94886c6a9275e1a67c34b084ddac5904c84492be"
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
