class Cpuid < Formula
  desc "CPU feature identification for Go"
  homepage "https://github.com/klauspost/cpuid"
  url "https://github.com/klauspost/cpuid/archive/refs/tags/v2.2.4.tar.gz"
  sha256 "66e5370b7f3c55e16ee72bf4d4f499421018e8e23fd1513a3f7ae23c0fb2785d"
  license "MIT"
  head "https://github.com/klauspost/cpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da79a7303b8a892333b09f1bb4a56e7159825ef5b8a3b420c158afa7cf4e951d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da79a7303b8a892333b09f1bb4a56e7159825ef5b8a3b420c158afa7cf4e951d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da79a7303b8a892333b09f1bb4a56e7159825ef5b8a3b420c158afa7cf4e951d"
    sha256 cellar: :any_skip_relocation, ventura:        "c695e46d5dd304c86e0b8f780cfe26ff4f5e081e5f41599652218002af45dbd1"
    sha256 cellar: :any_skip_relocation, monterey:       "c695e46d5dd304c86e0b8f780cfe26ff4f5e081e5f41599652218002af45dbd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c695e46d5dd304c86e0b8f780cfe26ff4f5e081e5f41599652218002af45dbd1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e11f0c0c8e9b43413c48c73d62ad3031198c0c1f1782e96d7d4f4d7e25406d8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cpuid"
  end

  test do
    json = shell_output("#{bin}/cpuid -json")
    assert_match "BrandName", json
    assert_match "VendorID", json
    assert_match "VendorString", json
  end
end
