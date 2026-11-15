class PythonGdbmAT311 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.11.18/Python-3.11.18.tgz"
  sha256 "5f62711b12470fd435f83f1451c1b1ef4a179aebc715c716874b0967567d814e"
  license "Python-2.0"

  livecheck do
    formula "python@3.11"
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "8c2078841d3287b715f58c375df9ac5b14dd0d94ed4b1de000432683b6edbe8b"
    sha256 cellar: :any, arm64_tahoe:       "19583da8acc066c817702c2840c97f65355407502086c6fccba5a20e0d19497a"
    sha256 cellar: :any, arm64_sequoia:     "c7f4bd4a3a53adab21116d901ad8a98fd55b3c0ee6d84e82de7af9d67da41407"
    sha256               arm64_linux:       "df89d2cb71ac3084800419d560ace1ca3768d88a10919ac81c60c4c6ffc64109"
    sha256               x86_64_linux:      "1a542ee0b0207b149a7e35410455037d40722daaccf4d1fe786e2bc55837c39e"
  end

  # https://devguide.python.org/versions/#versions
  deprecate! date: "2027-11-01", because: :deprecated_upstream
  disable! date: "2028-11-01", because: :deprecated_upstream

  depends_on "gdbm"
  depends_on "python@3.11"

  deny_network_access!

  def install
    cd "Modules" do
      (Pathname.pwd/"setup.py").write <<~PYTHON
        from setuptools import setup, Extension

        setup(name="gdbm",
              description="#{desc}",
              version="#{version}",
              ext_modules = [
                Extension("_gdbm", ["_gdbmmodule.c"],
                          include_dirs=["#{formula_opt_include("gdbm")}"],
                          libraries=["gdbm"],
                          library_dirs=["#{formula_opt_lib("gdbm")}"])
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
