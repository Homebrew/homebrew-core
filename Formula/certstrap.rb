class Certstrap < Formula
  desc "Tools to bootstrap CAs, certificate requests, and signed certificates"
  homepage "https://github.com/square/certstrap"
  url "https://github.com/square/certstrap.git",
      :tag => "v1.1.0",
      :revision => "25e0caa16bbb614597a4de836537084a16b28ca0"

  bottle do
    rebuild 1
    sha256 "b6ae41f23e2e588ec637558a68ab4d0d279326713bbf443fc8a26c7f9340498f" => :sierra
    sha256 "a6468f4513ef3490f786a1079701d3b22d44a59dc2b1ddf70b1e43b726365e70" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    system "./build"
    bin.install "bin/certstrap"
  end

  test do
    system "#{bin}/certstrap", "init", "--common-name", "Homebrew Test CA", "--passphrase", "beerformyhorses"
  end
end
