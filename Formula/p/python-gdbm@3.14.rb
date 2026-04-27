class PythonGdbmAT314 < Formula
  desc "Python interface to gdbm"
  homepage "https://www.python.org/"
  url "https://www.python.org/ftp/python/3.14.4/Python-3.14.4.tgz"
  sha256 "b4c059d5895f030e7df9663894ce3732bfa1b32cd3ab2883980266a45ce3cb3b"
  license "Python-2.0"
  revision 1

  livecheck do
    formula "python@3.14"
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "af951802d8bc5eaff5946695ad920e07bd63bf42cc3adb39c5982492b20dce02"
    sha256 cellar: :any, arm64_sequoia: "ce335535fc843258897a9ff3b5437fe803223548e478940aff325c8ea8229b75"
    sha256 cellar: :any, arm64_sonoma:  "179b4e15ef0bb92af5873b463c4c8cbf463a393ea798dbf089804bec6403e6a0"
    sha256 cellar: :any, sequoia:       "d4ba21e50a4100e0ec29f9bc03ec3287cbe4c3307363087b18ae626fe5b6a2c3"
    sha256 cellar: :any, sonoma:        "437dc8334c48f8cb6a72419558de2935232b97d5e3f807023605d6bc77f7c4a8"
    sha256               arm64_linux:   "5a732c7318b12eb0400d31a7a21de9de5230da97a1c618ff5228c1d8cfcda1ff"
    sha256               x86_64_linux:  "28c28d97cb5f8adcfd5e62f7a126e79bf5b46c4a55d49c272243a1561f32c630"
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

    (buildpath/"Modules/pyproject.toml").append_lines <<~TOML if OS.linux?
      [[tool.setuptools.ext-modules]]
      name = "_dbm"
      sources = ["_dbmmodule.c"]
      include-dirs = ["#{Formula["gdbm"].opt_include}", "#{python_include}/internal"]
      libraries = ["gdbm_compat"]
      library-dirs = ["#{Formula["gdbm"].opt_lib}"]
      extra-compile-args = ["-DUSE_GDBM_COMPAT", "-DHAVE_GDBM_DASH_NDBM_H"]
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

    return unless OS.linux?

    (testpath/"dbm_test.py").write <<~PYTHON
      import dbm

      with dbm.ndbm.open("test", "c") as db:
        db[b"foo \\xbd"] = b"bar \\xbd"
      with dbm.ndbm.open("test", "r") as db:
        assert list(db.keys()) == [b"foo \\xbd"]
        assert b"foo \\xbd" in db
        assert db[b"foo \\xbd"] == b"bar \\xbd"
    PYTHON
    system python3, "dbm_test.py"
  end
end
