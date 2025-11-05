class Nemu < Formula
  desc "Ncurses UI for QEMU"
  homepage "https://github.com/nemuTUI/nemu"
  url "https://github.com/nemuTUI/nemu/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "e272b3e80623f8aef66c3ecb5e2d8846ac89b2514a4bbb5026e74f51c1a5ef42"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "e6f30abdf8f40e196974dad2c6f80ffb5353c98997f4a0733c388c0515e34ae8"
    sha256 arm64_sequoia: "4069114fbb7f617e8f43ed1e3c3fb0f7c61bc99802ad84ae933b34526814d236"
    sha256 arm64_sonoma:  "fff82177fe56ae398e0c174948400f1c36821185bcdbf96d04accc7f461dbe0c"
    sha256 sonoma:        "bd4227695993da67ba07b55f0ee3eb3e671f33444dd013a62b060c76937489d2"
    sha256 arm64_linux:   "53aa94025e389c228af7eae6478da28df2bc57dcae31ed8c19b594a923bff202"
    sha256 x86_64_linux:  "cc06ac5e231324623d7ef68c67c5a77c545b8c33aa1a1170357b6e62d8af8f21"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libarchive"
  depends_on "ncurses"
  depends_on "openssl@3"

  uses_from_macos "libxml2"
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
