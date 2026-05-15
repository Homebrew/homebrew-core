class Dante < Formula
  desc "SOCKS server and client, implementing RFC 1928 and related standards"
  homepage "https://www.inet.no/dante/"
  url "https://www.inet.no/dante/files/dante-1.4.4.tar.gz"
  sha256 "1973c7732f1f9f0a4c0ccf2c1ce462c7c25060b25643ea90f9b98f53a813faec"
  license "BSD-Inferno-Nettverk"

  livecheck do
    url "https://www.inet.no/dante/download.html"
    regex(/href=.*?dante[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0e07933bcf9bcb90be5f3f0ff41bf6784fe6e3ad0c9f9eac9453513766c163ec"
    sha256 cellar: :any,                 arm64_sequoia: "641448e8ab837bdf0b8a87a78e06af469dad0f91f571af7a60a011613493a8df"
    sha256 cellar: :any,                 arm64_sonoma:  "182ff68f6b022decb171a5fb8b6d0493bc5aa10da185047874467d053c3ac600"
    sha256 cellar: :any,                 arm64_ventura: "1323b5c036625451c134161ec41b96efeb9bb6b0f10109fac0eb8680d3e87b0e"
    sha256 cellar: :any,                 sonoma:        "eacc7bdd820155843dc2d63c0854c269fde6b593b8848de7aa44b3519f8da57b"
    sha256 cellar: :any,                 ventura:       "314f9bdede43b188b66a6e477362f7a05067aad5139596a511a3f6268bd718ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6411a6d10e9db93d0f71d4475e9ddd3eac46276060ff2ecf64d4affc2ba78bcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcee07022a78c86b18501024615b999f7d3127a155a47bfbd2e2eec01cdb6e65"
  end

  uses_from_macos "libxcrypt"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-silent-rules",
                          # Enabling dependency tracking disables universal
                          # build, avoiding causing size or memmove detection issues.
                          "--enable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/dante"
    system "make", "install"
  end

  test do
    system sbin/"sockd", "-v"
  end
end
