class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/kornelski/dssim"
  url "https://github.com/kornelski/dssim/archive/2.11.3.tar.gz"
  sha256 "fa254c8f625e3ffdf563e4e665ac1e345195073cb57415bc2034c6ad602a76cb"
  license "AGPL-3.0-or-later"

  bottle do
    cellar :any_skip_relocation
    sha256 "d8eb6a36277a6dc7943aa09d07360e1b6f020074b8f0e98a67673d6542f77973" => :catalina
    sha256 "c03454b7582f988de44af524a342e016b3bf63937496450365c758809e79a224" => :mojave
    sha256 "f1284c6d8db31ce548232d0e7c0d4204249555ee5a9c92958b2c8bea4deee832" => :high_sierra
    sha256 "61c6019667ce76ccc145381eea2131ee3119366b1d54d2878da908eca8f85339" => :sierra
  end

  depends_on "nasm" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
