class Mpc < Formula
  desc "Command-line music player client for mpd"
  homepage "https://www.musicpd.org/clients/mpc/"
  url "https://www.musicpd.org/download/mpc/0/mpc-0.30.tar.xz"
  sha256 "65fc5b0a8430efe9acbe6e261127960682764b20ab994676371bdc797d867fce"

  bottle do
    sha256 "baffb4e58d39af2f18d3def335cb231826e1a94fafa4f31367e7372dbbfe769f" => :high_sierra
    sha256 "400ac144b7f8ca93a2cf2489e0b25031a0086b95e283c6537b037acf008e80cf" => :sierra
    sha256 "0ed8bc8a4a93e8df393e23d19229719ff057ebd3a6e27ff42324451753c399d0" => :el_capitan
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libmpdclient"

  def install
    system "meson", "--prefix=#{prefix}", ".", "output"
    system "ninja", "-C", "output"
    system "ninja", "-C", "output", "install"
  end

  test do
    assert_match "query", shell_output("#{bin}/mpc list 2>&1", 1)
  end
end
