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
    sha256 cellar: :any, arm64_sequoia: "03c7d5d93fe02d764f66d287188440d3d8b727944e4e05b44458f72c79aafda0"
    sha256 cellar: :any, arm64_sonoma:  "1a95fa06da08cc50c747500f1d918d65da7f28ee56540056113ed168b62ab288"
    sha256 cellar: :any, arm64_ventura: "2e733b75eca25aed79745fdbeb559be7103b450dd86c83d7bd303e29242ad241"
    sha256 cellar: :any, sonoma:        "7807e191cef5a479e2efec1796358b78b4771760286112ba717cd7146dbc086f"
    sha256 cellar: :any, ventura:       "a5a9f0666caaaab2aee72cf110c2cf7b34b61e0c8073e7dfaf219c0ac5b81a73"
    sha256               arm64_linux:   "64fa562166c39de690de2804119f8152b0a93d545dd67cea0f04237e1d1d2a34"
    sha256               x86_64_linux:  "6c3b3d989e12709e6fea2692c5e6cf14179bbbc8790df47058f5aa1a72b56eba"
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
