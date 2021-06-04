class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/v2.4.2.tar.gz"
  sha256 "89912b4af0abf532dca40eda404b4dcd301c677bf5a8b0d22e73963cb134a770"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "19d2e5d34d60dbcbc1bd68b630f6a910f71f51212245bfe1eca03a53c9aa4a11"
    sha256 cellar: :any_skip_relocation, big_sur:       "71345b0533fc6a2f4e923a76cf179617cee16511295734b1e5b263cd919605e6"
    sha256 cellar: :any_skip_relocation, catalina:      "114262fa636aee768296d61e84d87cbc6c0b2fe163ac415cafe94b19a16633a8"
    sha256 cellar: :any_skip_relocation, mojave:        "03aecf8deeaf6655a9b9d8988c95e6501a5434492fb9ab809f7d5fbcb48d226f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "failed to fetch root page: lookup does.not.exist: no such host",
        shell_output("#{bin}/muffet https://does.not.exist 2>&1", 1)

    assert_match "https://httpbin.org/",
        shell_output("#{bin}/muffet https://httpbin.org 2>&1", 1)
  end
end
