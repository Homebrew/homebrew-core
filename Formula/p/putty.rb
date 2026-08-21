class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "https://putty.software/"
  url "https://the.earth.li/~sgtatham/putty/0.85/putty-0.85.tar.gz"
  sha256 "13fd4db2936d03b73812a7bcc2a658e4dd29cc776a56c3670a7fc6f1a0ee8af8"
  license "MIT"
  head "https://git.tartarus.org/simon/putty.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a4e421f1fa6345d1ac144df17dde9b51ed850ccf2f455f78c425745e18893e24"
    sha256 cellar: :any, arm64_sequoia: "9827f9974dab6b05e1cd8afc5b54332a91f2b070b5011452c6358631e21fa3bd"
    sha256 cellar: :any, arm64_sonoma:  "7926b63799e359c16920b4adc709349d7643f0e3c3d8a5b5593272df227646e7"
    sha256 cellar: :any, sonoma:        "be46bf5d09cb2255f9c31c8bb223cef56c368007c89ada9697d96bb1bac5b767"
    sha256 cellar: :any, arm64_linux:   "6efe8b3b257063721dfd653918a6f449bf711d859dbc68abc8151847a4a8e5cc"
    sha256 cellar: :any, x86_64_linux:  "6f2d73f3c6e67b86e2cab8dbc634c6389267f0ea693802af27f5615e701a4e46"
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
    depends_on "libxrender"
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
