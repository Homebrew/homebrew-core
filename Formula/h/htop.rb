class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://htop.dev/"
  url "https://github.com/htop-dev/htop/archive/refs/tags/3.5.0.tar.gz"
  sha256 "cf0e72abf670ff3547d9130e129d2a97a657a5b20c74132c17502c817babbb41"
  license "GPL-2.0-or-later"
  head "https://github.com/htop-dev/htop.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "369ff52f70afd4c75d510bdf9b42ae12bdab9e1bf66f7b78576af9ba435f2b43"
    sha256 cellar: :any,                 arm64_sequoia: "6d5d637f6d7d41e5141f8a0ece4618abc05fe28f6fb9421872b05adbc2fe2657"
    sha256 cellar: :any,                 arm64_sonoma:  "5828b75524bb51a675a63b8bb1fdf6e0761c5f539840e6b02a99780dbbbbf698"
    sha256 cellar: :any,                 sonoma:        "914423941ea5b5a00441a4968fe28bf547a08292e796a6cee4e8edf9d60e5488"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a7e15a155aeaca4259c593e30cf350348f577d8eb5ca33bd27200e8d7a2ef70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7eb97c67292f87e0e3560f5e3b0f7f0edc07d12b99657aa5ce1c3c3cd9b4dc21"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "ncurses" # enables mouse scroll

  on_linux do
    depends_on "lm-sensors"
  end

  def install
    system "./autogen.sh"
    args = ["--prefix=#{prefix}"]
    args << "--enable-sensors" if OS.linux?
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      htop requires root privileges to correctly display all running processes,
      so you will need to run `sudo htop`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    pipe_output(bin/"htop", "q", 0)
  end
end
