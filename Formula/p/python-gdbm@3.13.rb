class PythonGdbmAT313 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.13.13/Python-3.13.13.tgz"
  sha256 "f9cde7b0e2ec8165d7326e2a0f59ea2686ce9d0c617dbbb3d66a7e54d31b74b9"
  license "Python-2.0"

  livecheck do
    formula "python@3.13"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "4f0b90daf6113e4455830221ffa45d94a9ffbc3c65ab15dccae2d8a2a0e8fde5"
    sha256 cellar: :any, arm64_sequoia: "e772e13a904c47f2d32b6ba498eaf788971cb8e9bc4ed0fb53956d13eaaf4ae9"
    sha256 cellar: :any, arm64_sonoma:  "a6401304a2b5a549a2e2d7a7c9342a9ffe7a6d610b7eb8d62ff4fa0acea6894c"
    sha256 cellar: :any, sequoia:       "b3aaec80426d9f394bf6bda59af35e5cc8db0a1f80b368c835ff47bc1eabbd70"
    sha256 cellar: :any, sonoma:        "806c21653194f973a53e67ee7239d96dc2381b434a33ed5e9298d19faa6ae335"
    sha256               arm64_linux:   "d035cdad2ec2014da285db3729e607666eabffd678f0e863df63861f09fa30ca"
    sha256               x86_64_linux:  "864602cffef5025b46a9ef7a038db81f1e4bd4e0c1df7bce6bd3d395187204b9"
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
