class Htop < Formula
  desc "Improved top (interactive process viewer)"
  homepage "https://htop.dev/"
  url "https://github.com/htop-dev/htop/archive/3.0.2.tar.gz"
  sha256 "b4744a3bea279f2a3725ed8e5e35ffd9cb10d66673bf07c8fe21feb3c4661305"
  license "GPL-2.0-or-later"
  head "https://github.com/htop-dev/htop.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "059d986c7148b98f3fceea5944d9cfa799dd9bc5e43b4d0daed4bb1f9a756ebf" => :big_sur
    sha256 "5bfd853dd4f051eb9a53c85ccdf21f66691f1a839036f5cff6c20a1f0ab05967" => :catalina
    sha256 "8b577984d03fd78706384024e579dc68df3a96013fc35d251534281ff3ec7ae4" => :mojave
    sha256 "1187ac4a948631e883539e0d2dd2362a1a64292ea562cf58ba8ec0b061150a49" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "ncurses" # enables mouse scroll

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
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
    pipe_output("#{bin}/htop", "q", 0)
  end
end
