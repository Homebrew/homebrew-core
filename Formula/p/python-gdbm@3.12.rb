class PythonGdbmAT312 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.12.9/Python-3.12.9.tgz"
  sha256 "45313e4c5f0e8acdec9580161d565cf5fea578e3eabf25df7cc6355bf4afa1ee"
  license "Python-2.0"

  livecheck do
    formula "python@3.12"
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "1b0c3d6bd5f57889bcdd6cd32cb8043039c5364aa2a9d5eb1f7c06280a491495"
    sha256 cellar: :any, arm64_sonoma:  "a6e4eb2a295132bef684432755a51a2d81fcdb623f142ed470a93dd1cf186a4b"
    sha256 cellar: :any, arm64_ventura: "09d72e8b50f3d7127928e0b4be01fc3ea78b2a7e5db54b972c61b37db9426740"
    sha256 cellar: :any, sonoma:        "bec48510afed5a70e4b12e12d2fe7dfd3f18c77a1c505d30896d231f4bf8e5be"
    sha256 cellar: :any, ventura:       "eb5d5bd4499200b80cfb366f90aa5e6c1b610da95f191684fc7bcd83be0b6d6d"
    sha256               x86_64_linux:  "960df19cff7d29d6f701b3a8b6471cf565214805935e09028d66f5d169306045"
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
