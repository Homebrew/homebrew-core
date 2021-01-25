class Lft < Formula
  desc "Layer Four Traceroute (LFT), an advanced traceroute tool"
  homepage "https://pwhois.org/lft/"
  url "https://pwhois.org/dl/index.who?file=lft-3.91.tar.gz"
  sha256 "aad13e671adcfc471ab99417161964882d147893a54664f3f465ec5c8398e6af"

  livecheck do
    url :homepage
    regex(/value=.*?lft[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d54a6ac61b9a1f7d1106dc0d8fbff8223b606baeb2ccca9a325f8f79e443fb77" => :big_sur
    sha256 "fef7ddeb57e6b035f5eda5cf55180152cd77f531e1672a5d443fcac2e7f7d7dd" => :arm64_big_sur
    sha256 "c0b69000709a507f2ec0cc2ff286910e6f2629169367828cfdc26e184654f787" => :catalina
    sha256 "83d6fa2b78fb9780fecb9287407825d1731f1c91da30bb75b15f26e632e0720b" => :mojave
    sha256 "e0370a6053bedd5c24f62583c2d19c3d0d2fab2fa5cf9003561e60694dad8642" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "isn't available to LFT", shell_output("#{bin}/lft -S -d 443 brew.sh 2>&1")
  end
end
