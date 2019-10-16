class Inadyn < Formula
  desc "Dynamic DNS client with IPv4, IPv6, and SSL/TLS support"
  homepage "https://troglobit.com/projects/inadyn/"
  url "https://github.com/troglobit/inadyn/releases/download/v2.5/inadyn-2.5.tar.gz"
  sha256 "f7faf0be4f0b4bfa1acc811189a9ed0a58bc367e48ea31c283920a2ef27cdc40"

  bottle do
    sha256 "3f03070bad5247eab88623753d6c4c3f60c197cc7c629324afbaefaf0d9d8560" => :catalina
    sha256 "6e74812d53caa2ae34d2c571e7e2a0575de36aeec1504c0c840ce7e5cdf7e1b0" => :mojave
    sha256 "870e29d1856c85414d2566d2d5a9d39de1c2aa6846c6c9c3647c29ea4be588b8" => :high_sierra
    sha256 "d2ee8d33a5069f120081ea1c70ecd600bc516e7e0b09658d3196f1df6e40029a" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake"    => :build
  depends_on "libtool"  => :build
  depends_on "confuse"
  depends_on "gnutls"
  depends_on "pkg-config"

  # Fix for Sierra with v2.5, remove in next version
  patch do
    url "https://github.com/troglobit/inadyn/commit/57bdcc0321b49ee68397c70140d9895655edb06f.diff?full_index=1"
    sha256 "6d24c3822e7017a471583f5424421d83e6e426b464ca7521db943ecec580eea5"
  end

  def install
    mkdir_p buildpath/"inadyn/m4"
    system "autoreconf", "-vif"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  test do
    system "#{sbin}/inadyn", "--check-config", "--config=#{HOMEBREW_PREFIX}/share/doc/inadyn/examples/inadyn.conf"
  end
end
