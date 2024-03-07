class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https://github.com/noir-cr/noir"
  url "https://github.com/noir-cr/noir/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "2fa8e8956fb16a69aefcfc3538fae95c96fa3e68467e41fece6fc1d6e4433363"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "9864205ce2934b455634a41704c0fdf97a7041693037da354b5862e8ba8a568e"
    sha256 arm64_ventura:  "7204b29a91984b6156bdf805c47656f6c1f0ae0ac20a325964c3933a0b7efe9c"
    sha256 arm64_monterey: "eb35fd3ab6691bd60df4dbb0eafb2ad6cc4dfd11190ec5cec0c6ccb92f482f05"
    sha256 sonoma:         "6cec1d3ea1d4674594358abb61d26026844fabe05a1d9e343d7bc5ef9c2240d0"
    sha256 ventura:        "200a3f8f7bb6c6bdbe0953e988168bcd0716e6d26ef0732dafac2f5181b9763e"
    sha256 monterey:       "4a86b9dba90c67a4bf4d7a26ac22d4fc5415b0fceb8d51cfd0d43e486af4ca2b"
    sha256 x86_64_linux:   "580682738589b8f74565fdc57ecf560be4090c0f09b1a33bc8976593e1216e15"
  end

  depends_on "crystal"

  def install
    system "shards", "install"
    system "shards", "build", "--release", "--no-debug"
    bin.install "bin/noir"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/noir --version")

    system "git", "clone", "https://github.com/noir-cr/noir.git"
    output = shell_output("#{bin}/noir -b noir 2>&1")
    assert_match "Generating Report.", output
  end
end
