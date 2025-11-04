class Nemu < Formula
  desc "Ncurses UI for QEMU"
  homepage "https://github.com/nemuTUI/nemu"
  url "https://github.com/nemuTUI/nemu/archive/refs/tags/v3.4.0.tar.gz"
  sha256 "e272b3e80623f8aef66c3ecb5e2d8846ac89b2514a4bbb5026e74f51c1a5ef42"
  license "BSD-2-Clause"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "a85570304ed9582ca07aab731b00e4cd2e4f88b4dfddaeacf119d5362f1dc670"
    sha256 arm64_sequoia: "f8e00617670f088a45154eed42c7a37257d23692128cb325e880df8fd340c834"
    sha256 arm64_sonoma:  "85ed732c4c8c5a1289c3d78d425798876f32d6a3095c04a744d4ef1f32339c4d"
    sha256 sonoma:        "988e07f3dc2a6a26b82a63b6583775f48b7d8eeed7ca2a648d5ada870d9d97de"
    sha256 arm64_linux:   "8587fe0509237203b730dd4736cec438559fb2e52c2fe2c219d0764e69851be4"
    sha256 x86_64_linux:  "a3b5579daa967e5637df12043eaef848eacc00d9dbc44a4180cfec9d3730a467"
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
