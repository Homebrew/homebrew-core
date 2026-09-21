class Nemu < Formula
  desc "Ncurses UI for QEMU"
  homepage "https://github.com/nemuTUI/nemu"
  url "https://github.com/nemuTUI/nemu/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "dc251c6c478d60734a964324c028904e9da97dfeded7e5c6855f65e594e9a065"
  license "BSD-2-Clause"

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "ada86ab170e4c827e2c841ec4c96f3ec2274c7ee4288cb1a21913eabb02ea174"
    sha256 arm64_tahoe:       "22d05d93d1deb46f0103f7cdb6ac44697bb3e5494b2cb41cd37f675d860453d2"
    sha256 arm64_sequoia:     "fa5178f8c869ce40993be28a1410ea7b7bb77c16cd2b6bc9abb4592bf1964c11"
    sha256 arm64_linux:       "265283a0c431a5ffd015104a6b0936d65bdb86b1669f88c8ddbb837609d07750"
    sha256 x86_64_linux:      "cc70ecef5271f8e8aca65da93e205e44a46ac692394110f1c81b08802f2a1931"
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
