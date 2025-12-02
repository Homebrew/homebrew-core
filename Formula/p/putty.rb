class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "https://putty.software/"
  url "https://the.earth.li/~sgtatham/putty/0.83/putty-0.83.tar.gz"
  sha256 "718777c13d63d0dff91fe03162bc2a05b4dfc8b0827634cd60b51cefdff631c6"
  license "MIT"
  head "https://git.tartarus.org/simon/putty.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4435fad45783e698f8e87ac2a9c4a99aa0341cbe7b5a3f4f200cb8e8daa6852f"
    sha256 cellar: :any,                 arm64_sequoia: "d1f1bb98a018698957ee04e663858ef5c0ccbcb2467d611043b0e71c3f2d62f0"
    sha256 cellar: :any,                 arm64_sonoma:  "188ad54b237bb00dfcea34a591d99fb6b6cbeb2595300b2e010c029c282194d6"
    sha256 cellar: :any,                 arm64_ventura: "3e07713c84bc44c06f74d946194006f3f3b3e231ab2a16bd7d55bdd6663eb80b"
    sha256 cellar: :any,                 sonoma:        "4578c6f0f69004373c7e7f99d7a5c11a46884bc361aa3817f02ea89a1a78c4bf"
    sha256 cellar: :any,                 ventura:       "41a0e25f2b1fedad2710a1aceb2f399eb3c0b6ab52f4efb8509d3153c70aad34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8ecc1dafeb153935ef7ea554f65257fa91109f67b1a569e92d750f07c4d6445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7401a1dd4eeb3dd9d0ff69ac9c60f88a3174cc143bbc321803b604d00249e8e2"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "pango"

  uses_from_macos "perl" => :build

  on_linux do
    depends_on "libx11"
  end

  conflicts_with "pssh", because: "both install `pscp` binaries"

  def install
    args = ["-DPUTTY_GTK_VERSION=3"]
    args << "-DCMAKE_EXE_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac? # to reduce overlinking

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    require "expect"
    require "pty"

    PTY.spawn(bin/"puttygen", "-t", "rsa", "-b", "4096", "-q", "-o", "test.key") do |r, w, _pid|
      r.expect "Enter passphrase to save key: "
      w.write "Homebrew\n"
      r.expect "Re-enter passphrase to verify: "
      w.write "Homebrew\n"
      r.read
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end

    assert_path_exists testpath/"test.key"
  end
end
