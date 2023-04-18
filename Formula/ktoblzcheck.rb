class Ktoblzcheck < Formula
  desc "Library for German banks"
  homepage "https://ktoblzcheck.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ktoblzcheck/ktoblzcheck-1.53.tar.gz"
  sha256 "18b9118556fe83240f468f770641d2578f4ff613cdcf0a209fb73079ccb70c55"
  license "LGPL-2.1-or-later"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/ktoblzcheck[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "8085c03ee7b21d4a949509374263b39fb130b94b7e890aaf80262a7d5d773215"
    sha256 arm64_monterey: "83a69f2e2a4d5c7e9c96118037337f34e4ec28569d89532afc7ad7e41951e717"
    sha256 arm64_big_sur:  "42680d8ba1e53d95f2ce71111b443f55806da778881ac2cc8cc06febd9c023f8"
    sha256 ventura:        "d08a40ea385d6160d575466104d0869a282284d37dcad2b8cffaf5eb58dbc258"
    sha256 monterey:       "72a3fce8f0c8f1dcfbed9779e04b74e3bb4df4db2b5610bc066e90906e507d0c"
    sha256 big_sur:        "d9abaad3e06fa41e6864ba91fd2dcd9dec86a4a3e5150a330981f5d557ba7b1d"
    sha256 catalina:       "e0400495c056dc0f0a0de0345b468bbdb19483f93cbd0d7b5e5c3f1446654937"
    sha256 x86_64_linux:   "85fdd6479c9fe84018dc2b4a25e83737271a8bd0e85cdde03a71f45438af368e"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11"

  def install
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
    system "python3.11", "-c", "import ktoblzcheck"
  end
end
