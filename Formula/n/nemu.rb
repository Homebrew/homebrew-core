class Nemu < Formula
  desc "Ncurses UI for QEMU"
  homepage "https://github.com/nemuTUI/nemu"
  url "https://github.com/nemuTUI/nemu/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "a956b23a492c1d6362a04ef7a88fb62763c2ba5e019d13841e42dec4f3d0d707"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_tahoe:   "8b0f547045eeb45bed56f2e2e94afe95839fe6980238b7e2ab88b9f77e24bc62"
    sha256 arm64_sequoia: "f5999e45447d2c4a6aa7dcbc37c9cac3954337ee435dc90947de12e0b7091367"
    sha256 arm64_sonoma:  "1b7228daf1116bade34ca09e93894c26c29b4fa53b0272aadc08decc45ccb543"
    sha256 sonoma:        "5b68f304698644c440396d1231340c070085d06f2491baee91f795ab6d052915"
    sha256 arm64_linux:   "84cba712847c252430dd9ea00b2cf00fbe892cff4b14c57619b76bf1b74c852d"
    sha256 x86_64_linux:  "eb07752126a372cd97200e2493f265c7dc9d36f6af78c55d02ebb70de98a5bc3"
  end

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "pkgconf" => :build
  depends_on "json-c"
  depends_on "libarchive"
  depends_on "ncurses"
  depends_on "openssl@3"

  uses_from_macos "libxml2"
  uses_from_macos "sqlite"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "libusb"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    expected = /^Config file .* is not found.*$/
    assert_match expected, pipe_output("XDG_CONFIG_HOME=#{Dir.home} #{bin}/nemu --list", "n")
  end
end
