class PythonGdbmAT314 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.4/Python-3.14.4.tgz"
  sha256 "b4c059d5895f030e7df9663894ce3732bfa1b32cd3ab2883980266a45ce3cb3b"
  license "Python-2.0"

  livecheck do
    formula "python@3.14"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1bef27f3b0d3a83a41e0ff854052b560848f21c0ae08d19221fee8ceb7322511"
    sha256 cellar: :any, arm64_sequoia: "606abcbb6f1a952481671850346ef38b64e33bc76cc2f587ef3da89eb206898a"
    sha256 cellar: :any, arm64_sonoma:  "2f22db62ae2601143417c1ba4a575d4b3137bb03c49fea8f338d5e8ae083c0b8"
    sha256 cellar: :any, sequoia:       "999aa26f8f53dba6ca07e765f7516dd5ef3b68d31c1c630508d6b30b176f564c"
    sha256 cellar: :any, sonoma:        "203e25fa170e365fdb196a0cd7aee90d7a877d59ce49f0227e5808292a4fa108"
    sha256               arm64_linux:   "3030dc120dee0c17373bdf8024cfdf17dba4e459443d03fb0addaf56a5c9bf49"
    sha256               x86_64_linux:  "08f842f1f18d922ee49c49ddae728e9659b34fa5b3284a0f060375e7212496ca"
  end

  depends_on "gdbm"
  depends_on "python@3.14"

  def python3
    "python3.14"
  end

  def install
    xy = Language::Python.major_minor_version python3
    python_include = if OS.mac?
      Formula["python@#{xy}"].opt_frameworks/"Python.framework/Versions/#{xy}/include/python#{xy}"
    else
      Formula["python@#{xy}"].opt_include/"python#{xy}"
    end

    (buildpath/"Modules/pyproject.toml").write <<~TOML
      [project]
      name = "gdbm"
      version = "#{version}"
      description = "#{desc}"

      [tool.setuptools]
      packages = []

      [[tool.setuptools.ext-modules]]
      name = "_gdbm"
      sources = ["_gdbmmodule.c"]
      include-dirs = ["#{Formula["gdbm"].opt_include}", "#{python_include}/internal"]
      libraries = ["gdbm"]
      library-dirs = ["#{Formula["gdbm"].opt_lib}"]
    TOML

    system python3, "-m", "pip", "install", *std_pip_args(prefix: false, build_isolation: true),
                                            "--target=#{libexec}", "./Modules"
    rm_r libexec.glob("*.dist-info")
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
