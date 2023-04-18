class Netcat < Formula
  desc "Utility for managing network connections"
  homepage "https://netcat.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/netcat/netcat/0.7.1/netcat-0.7.1.tar.bz2"
  sha256 "b55af0bbdf5acc02d1eb6ab18da2acd77a400bafd074489003f3df09676332bb"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b8d6a5ba62a3ea60b855cf4cff46ab35aeee9bb49966c3a769522a0df186a31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b67683e14760ec8ceda14c44b85d16411f5f3331e6385269fc6c1a4ee063273"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70fa1400d39bcb39a3452bca1c921d1cc76783d8fa2ad41b1742a0c317c1aceb"
    sha256 cellar: :any_skip_relocation, ventura:        "de0cce7840c9836ae8003805ca0817d03e8c54e62ff4044fee1085a97883d033"
    sha256 cellar: :any_skip_relocation, monterey:       "7c33ed98a6c81011f5923240e11b87f07add5cea280f5e2754b2f3d7fc3d9eee"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec93ed2ce809a78373e1b747f20075fabe5e9d612e2f84f85f125e4ce81eadb3"
    sha256 cellar: :any_skip_relocation, catalina:       "13bd349dfb08b3a5a474498eec4e20ffff722f82446b255d9c6e0540b02b362b"
    sha256 cellar: :any_skip_relocation, mojave:         "3ac133de6b67a147954d78b9bd0c4c4cf4e0f43bdbbb98f51d8d962bb752d973"
    sha256 cellar: :any_skip_relocation, high_sierra:    "879d9c32f09e9ef31cb672983707f9d95341f6639bb8a4db54d7a6ea0878b946"
    sha256 cellar: :any_skip_relocation, sierra:         "9027fd429d5407fba0b3206bd0cd198c669f4744155efcf8e0dbdd6ba69b6d34"
    sha256 cellar: :any_skip_relocation, el_capitan:     "1f346605e0236ea7880258da2abf0bde1d7d8d8735a07d6d32feaf12425ff6da"
    sha256                               x86_64_linux:   "713b509412561ffe59ef45f828278384180ffc219547d9495409908ba421e259"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    # Regenerate configure script for arm64/Apple Silicon support.
    system "autoreconf", "--verbose", "--install", "--force"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}"
    system "make", "install"
    man1.install_symlink "netcat.1" => "nc.1"
  end

  test do
    output = pipe_output("#{bin}/nc google.com 80", "GET / HTTP/1.0\r\n\r\n")
    assert_equal "HTTP/1.0 200 OK", output.lines.first.chomp
  end
end
