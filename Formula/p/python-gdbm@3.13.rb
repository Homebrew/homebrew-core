class PythonGdbmAT313 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.1/Python-3.13.1.tgz"
  sha256 "1513925a9f255ef0793dbf2f78bb4533c9f184bdd0ad19763fd7f47a400a7c55"
  license "Python-2.0"

  livecheck do
    formula "python@3.13"
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "21823032e5ee176d0936b3ebe34b2abd06b535cc8305a01a95700bee501a8f48"
    sha256 cellar: :any, arm64_sonoma:  "046211ad2e8514b384c895a8f4b78c817ab21d5cedb3c283797fe29167773a2f"
    sha256 cellar: :any, arm64_ventura: "d5069fdf214ec0a836b854723893afcd2ccd37ce6e2655906656ded3ac8f0d01"
    sha256 cellar: :any, sonoma:        "4491428a4ed84c3c6b7a068dcc9342a05ede076bbfe6160400f87d6afd0c5ffb"
    sha256 cellar: :any, ventura:       "778843cb00ccc5f7bf3dfd1444ff057a0096f2b81d34e71d1d3bf614c361a3c2"
    sha256               x86_64_linux:  "875d02ebf66ea2ec2429ec622a8671c513e0deb36e6cb90f0bf9ec8b7dfa34e9"
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
