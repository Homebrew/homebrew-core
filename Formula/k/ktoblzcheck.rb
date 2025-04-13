class Ktoblzcheck < Formula
  desc "Library for German banks"
  homepage "https://ktoblzcheck.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.57.tar.gz"
  sha256 "4c3b782e5d8e31e219c3e2ece0c6e84a93929ae0b2f36080d4c183a644d05672"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/ktoblzcheck[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "5b4500f5a3ebbd8c92500f18c84d5be4e91eb7522e2c46874b7272ae7f9aa7ab"
    sha256 arm64_sonoma:  "bf7974d2901add8dc0aaef564956b8a493efb58a8993456b48fcb4f374dbb201"
    sha256 arm64_ventura: "8abf58282c84ee2934cb1e3606814ee447dafb475e4206afdeddb05f0d410bcf"
    sha256 sonoma:        "dd3466c3a53c28c91005e0f610bfe634f7209577810cbc2d077ac3ba9aa39751"
    sha256 ventura:       "a99501a6e0001ab7e134a3687565454286231e435dc88b96eb2012e61e78debc"
    sha256 arm64_linux:   "e15de18b01a09811a3b5c99d095023c2a3a969365fe33ba0978dfd0ccdddb112"
    sha256 x86_64_linux:  "5b60fa4082c972f35e50f36319ee833f278ceb1e39b04ab008d796b2ddaee501"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13"
  depends_on "sqlite"

  uses_from_macos "curl"

  resource "et-xmlfile" do
    url "https://files.pythonhosted.org/packages/3d/5d/0413a31d184a20c763ad741cc7852a659bf15094c24840c5bdd1754765cd/et_xmlfile-1.1.0.tar.gz"
    sha256 "8eb9e2bc2f8c97e37a2dc85a09ecdcdec9d8a396530a6d5a33b30b9a92da0c5c"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/3d/f9/88d94a75de065ea32619465d2f77b29a0469500e99012523b91cc4141cd1/openpyxl-3.1.5.tar.gz"
    sha256 "cf0e3cf56142039133628b5acffe8ef0c12bc902d2aadd3e0fe5878dc08d1050"
  end

  def python3
    "python3.13"
  end

  def install
    ENV.append_path "PYTHONPATH", buildpath/Language::Python.site_packages(python3)
    resources.each do |r|
      r.stage do
        system python3, "-m", "pip", "install", *std_pip_args(prefix: buildpath, build_isolation: true), "."
      end
    end

    # Work around to help Python bindings find shared library on macOS.
    # OSError: dlopen(ktoblzcheck, 0x0006): tried: 'ktoblzcheck' (no such file), ...
    # OSError: dlopen(libktoblzcheck.so.1, 0x0006): tried: 'libktoblzcheck.so.1' (no such file), ...
    inreplace "src/python/ktoblzcheck.py", /'libktoblzcheck\.so\.(\d+)'/, "'libktoblzcheck.\\1.dylib'" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{opt_lib}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "Ok", shell_output("#{bin}/ktoblzcheck --outformat=oneline 10000000 123456789")
    assert_match "unknown", shell_output("#{bin}/ktoblzcheck --outformat=oneline 12345678 100000000", 3)
    system python3, "-c", "import ktoblzcheck"
  end
end
