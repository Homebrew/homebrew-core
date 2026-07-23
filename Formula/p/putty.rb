class Putty < Formula
  desc "Implementation of Telnet and SSH"
  homepage "https://putty.software/"
  url "https://the.earth.li/~sgtatham/putty/0.84/putty-0.84.tar.gz"
  sha256 "06057862ae198f1dbd219d0c7493080d59f606194bb5056c549e342aa01b69fe"
  license "MIT"
  head "https://git.tartarus.org/simon/putty.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "892f91f39035e15f001113fdaaba92845b6e554d1c5e3945f7d06c814c2e3673"
    sha256 cellar: :any,                 arm64_sequoia: "294e693b1708ff661d9a68afd4a4340500465142ba7b6ad33fd27577c0e912d8"
    sha256 cellar: :any,                 arm64_sonoma:  "da9014973e707444aaba812f9270657f0b9839375e2e5fe594ca600640cc36e2"
    sha256 cellar: :any,                 sonoma:        "67eb5e27869b0781f9fc833960ddd8c307d6030072c609c30504af4532bd5bd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2dbe37239a805fca18b7844a70fa5ed6b917e651b69288ee623c6cf1b048c6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c76fdc30ed072fe433722b84f2084cd7fe93b687d11da9f7e73622857a40391b"
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
