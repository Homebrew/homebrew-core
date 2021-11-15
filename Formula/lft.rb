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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4acd9a1fbaaafb14cd67002cf70cb78e262150995f7deea1f32c4f616de322b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fef7ddeb57e6b035f5eda5cf55180152cd77f531e1672a5d443fcac2e7f7d7dd"
    sha256 cellar: :any_skip_relocation, monterey:       "4500b7cf6a00acc2b8edb3a7f608508e23e4102feddbd5bdadf6b4a9edf3066f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d54a6ac61b9a1f7d1106dc0d8fbff8223b606baeb2ccca9a325f8f79e443fb77"
    sha256 cellar: :any_skip_relocation, catalina:       "c0b69000709a507f2ec0cc2ff286910e6f2629169367828cfdc26e184654f787"
    sha256 cellar: :any_skip_relocation, mojave:         "83d6fa2b78fb9780fecb9287407825d1731f1c91da30bb75b15f26e632e0720b"
    sha256 cellar: :any_skip_relocation, high_sierra:    "e0370a6053bedd5c24f62583c2d19c3d0d2fab2fa5cf9003561e60694dad8642"
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
