class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/putty/"
  url "https://the.earth.li/~sgtatham/putty/0.82/putty-0.82.tar.gz"
  sha256 "195621638bb6b33784b4e96cdc296f332991b5244968dc623521c3703097b5d9"
  license "MIT"
  head "https://git.tartarus.org/simon/putty.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "1f04c4696642d5238b62e185b9295284d5314bd1fe04468830330961aefe37ca"
    sha256 cellar: :any,                 arm64_sonoma:  "24503de6b2218e6f97f9bf379eddda08db9ef130c6e745c755b228b8a9c38f68"
    sha256 cellar: :any,                 arm64_ventura: "d3aebac833117e0ce39ab879d99ef707117af4167a230d896cf12be62520b358"
    sha256 cellar: :any,                 sonoma:        "c0db739c9cd658dffcf7f94989de0843f9502a4fbac9c09a376ca53151fe39ed"
    sha256 cellar: :any,                 ventura:       "b92fa9eed52a94f950dc138244837eb6429adf50e756a94b2f96f40abd69f30a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1676a17a56fdf1e36b7500e4e422d95f3b069a4753e0f28b2a12203841b1a60f"
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
