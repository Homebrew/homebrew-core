class FetchCrl < Formula
  desc "Retrieve certificate revocation lists (CRLs)"
  homepage "https://wiki.nikhef.nl/grid/FetchCRL3"
  url "https://dist.eugridpma.info/distribution/util/fetch-crl3/fetch-crl-3.0.21.tar.gz"
  sha256 "19a96b95a1c22da9d812014660744c6a31aac597b53ac17128068a77c269cde8"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c4aedc9178b36cf45d9a05ed4213c5c2ede584dc1c2754f2370b91f42a1efe3" => :catalina
    sha256 "7c4aedc9178b36cf45d9a05ed4213c5c2ede584dc1c2754f2370b91f42a1efe3" => :mojave
    sha256 "7c4aedc9178b36cf45d9a05ed4213c5c2ede584dc1c2754f2370b91f42a1efe3" => :high_sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "ETC=#{etc}", "CACHE=#{var}/cache"
  end

  test do
    system sbin/"fetch-crl", "-l", testpath
  end
end
