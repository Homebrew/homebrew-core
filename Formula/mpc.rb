class Mpc < Formula
  desc "Command-line music player client for mpd"
  homepage "https://www.musicpd.org/clients/mpc/"
  url "https://www.musicpd.org/download/mpc/0/mpc-0.30.tar.xz"
  sha256 "65fc5b0a8430efe9acbe6e261127960682764b20ab994676371bdc797d867fce"

  bottle do
    sha256 "09fa8de76bc150b211888404f51edb697c797299f577fcbd69db47b4fe4ba471" => :mojave
    sha256 "1d83b43f782bfdf0094c3f756e187ad09582419f51856ee2b3f20a22db083304" => :high_sierra
    sha256 "f8a0570ac6328165c03d502797d5d286787a1ff03ba16ede32ff166063000254" => :sierra
    sha256 "46b3077b453c93b13e6dc58cb9e54cb170a8fd774565d0afce98368632e6f9ae" => :el_capitan
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
