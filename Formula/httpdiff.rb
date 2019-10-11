class Httpdiff < Formula
  desc "Compare two HTTP(S) responses"
  homepage "https://github.com/jgrahamc/httpdiff"
  url "https://github.com/jgrahamc/httpdiff/archive/v1.0.0.tar.gz"
  sha256 "b2d3ed4c8a31c0b060c61bd504cff3b67cd23f0da8bde00acd1bfba018830f7f"
  head "https://github.com/jgrahamc/httpdiff.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5731d30f22cf63bd619c18f0f91c4547c52f2ae1b38a2cfeb0316958e93995c1" => :catalina
    sha256 "6113414a69c11632f0088e478d6db0acc6b826db7937c3570e661152c58bd334" => :mojave
    sha256 "1432608ef9e3ffaac9fc3c6207e63d888dd2246e1c806bc6a57cab312f944aea" => :high_sierra
    sha256 "39a0d685904aba4c3e55ff22b4d231b8890c022a1eb0366dc264bbabc410a117" => :sierra
    sha256 "59b46605118f8789c10facd53e9d4ce4c9f54c8de85611d423984c4316a169eb" => :el_capitan
    sha256 "d5919069e31192cfd6f7d33dd4ff80d2142a8c36d23b50291e914c158d91ffac" => :yosemite
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"httpdiff"
  end

  test do
    system bin/"httpdiff", "https://brew.sh/", "https://brew.sh/"
  end
end
