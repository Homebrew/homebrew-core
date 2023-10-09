class Nemu < Formula
  desc "Ncurses UI for QEMU"
  homepage "https://github.com/nemuTUI/nemu"
  url "https://github.com/nemuTUI/nemu/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "dea2d02e539d7c671e66c102684be5ee231fa9094a73c1ab2793817773e72ac7"
  license "BSD-2-Clause"

  bottle do
    sha256 arm64_sonoma:   "2f510c615ac4ecd999ad1da47fda562287a88ab9f306f25c584e1cf8276e56c9"
    sha256 arm64_ventura:  "f81d74612cdf8fe0d4ea6475ad3fcbda3a3a4a7434dca624adfe5f3afc93b7f8"
    sha256 arm64_monterey: "533618fd9355d18b458708f197a42e0316580f5543601f584d558f7c57504bca"
    sha256 sonoma:         "3cbef2efa4b26b2b0450b8a9684d0e178d672a647d399062a3ce2a112f033a31"
    sha256 ventura:        "eb98aaf401f12994a13e479d7553a5bf9bef557ff8ad0ebad1a3948d102a4b0b"
    sha256 monterey:       "64476c1b9e95eaf356583de9eaeaa47b54b2983cf51e1d39fd242691cd81f0fa"
    sha256 x86_64_linux:   "7103efd1f68a50098902722a678f84dfb5bd440b2a6048ebbda49cbe7d2aa7da"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libarchive"
  depends_on "ncurses"
  depends_on "openssl@3"

  uses_from_macos "sqlite"

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
