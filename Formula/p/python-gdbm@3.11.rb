class PythonGdbmAT311 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.13/Python-3.11.13.tgz"
  sha256 "0f1a22f4dfd34595a29cf69ee7ea73b9eff8b1cc89d7ab29b3ab0ec04179dad8"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_sequoia: "2a955537cf1e3948d9df0c9fe23f0c89ef96a6584efd76ca6b1ee2e6bd6ace8a"
    sha256 cellar: :any, arm64_sonoma:  "b8fb60ba4bff2890bd743112dfdbed71479cd36c816d13ab94cfa3796a428cff"
    sha256 cellar: :any, arm64_ventura: "1644e05e6f4ba70911d9a8c145ca72b9814afd8a1b09a783f127fff26403a2d1"
    sha256 cellar: :any, sonoma:        "65d30343e2643930ac205f5db0986a0ab74b3244414e9f4b9b179bb59a0be266"
    sha256 cellar: :any, ventura:       "2b7186466f629e677a36a16c3457b533be6ed3c37286b09dc6f8d8281f42e2b7"
    sha256               arm64_linux:   "1f590bc49cb71c68a750087dd60aa96cbcbf237da2bbab1d82978e2101d562f7"
    sha256               x86_64_linux:  "93d7da32f2cb39491d6438b2568c012b843dcd2fed90caafc958931bf0058c90"
  end

  depends_on "gdbm"
  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    cd "Modules" do
      (Pathname.pwd/"setup.py").write <<~PYTHON
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
      PYTHON
      system python3, "-m", "pip", "install", *std_pip_args(prefix: false), "--target=#{libexec}", "."
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
