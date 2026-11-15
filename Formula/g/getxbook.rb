class Getxbook < Formula
  desc "Tools to download ebooks from various sources"
  homepage "https://njw.name/getxbook/"
  url "https://njw.name/getxbook/getxbook-1.3.tar.xz"
  sha256 "a1b8252a50ba61e7c66a82161af35e08f4e6187e8c2cea1e2a040d167932de18"
  license "ISC"

  livecheck do
    url :homepage
    regex(/href=.*?getxbook[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "7793d356cf9b68b80252935afe198f9a762984db38dd7d100129b79ea8b72e2b"
    sha256 cellar: :any, arm64_tahoe:       "c6379b8509478c4deed1c672e2a6adae0a113885812edc61510ce706b436a2ea"
    sha256 cellar: :any, arm64_sequoia:     "7dc7859714c82d25b8b60eea5d33e25e0ae7846b8f7c7fae705871142d6a0a1c"
    sha256 cellar: :any, arm64_linux:       "a1e97e82598234f99cd802dceddf434c12c0dc690d137008739f9a7d35fb9e4f"
    sha256 cellar: :any, x86_64_linux:      "dc83d3c17c8d0c66559fd677418eabc6c2a1b7ebc6303a895ff7ea27bbd53443"
  end

  depends_on "openssl@4"

  deny_network_access!

  def install
    system "make", "CC=#{ENV.cc}", "PREFIX=#{prefix}"
    bin.install "getgbook", "getabook", "getbnbook"
  end

  test do
    assert_match "getgbook #{version}", shell_output("#{bin}/getgbook", 1)
  end
end
