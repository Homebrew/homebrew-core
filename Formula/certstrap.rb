class Certstrap < Formula
  desc "Tools to bootstrap CAs, certificate requests, and signed certificates"
  homepage "https://github.com/square/certstrap"
  url "https://github.com/square/certstrap/archive/v1.1.1.tar.gz"
  sha256 "412ba90a4a48d535682f3c7529191cd30cd7a731e57065dcf4242155cec49d5e"

  bottle do
    rebuild 1
    sha256 "168d381366cc94bd625de836d50064320130a09a3da9c6c2f973aebceb80482a" => :high_sierra
    sha256 "b6ae41f23e2e588ec637558a68ab4d0d279326713bbf443fc8a26c7f9340498f" => :sierra
    sha256 "a6468f4513ef3490f786a1079701d3b22d44a59dc2b1ddf70b1e43b726365e70" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/square").mkpath
    ln_s buildpath, "src/github.com/square/certstrap"
    system "go", "build", "-o", bin/"certstrap"
  end

  test do
    system "#{bin}/certstrap", "init", "--common-name", "Homebrew Test CA", "--passphrase", "beerformyhorses"
  end
end
