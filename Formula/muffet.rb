class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/v2.4.2.tar.gz"
  sha256 "89912b4af0abf532dca40eda404b4dcd301c677bf5a8b0d22e73963cb134a770"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8f8b66a8bd39cfa71c7a7016b511fca1dc1b2bd17f0c8283fee5fa4347e002ac"
    sha256 cellar: :any_skip_relocation, big_sur:       "349a736d1c3528138eac03f04eeed91656c1613a011e8db893d8080c85358ed4"
    sha256 cellar: :any_skip_relocation, catalina:      "9b2bd1e154add9821456d420105c25eabdf8cdd198224fc8172755569d5792fd"
    sha256 cellar: :any_skip_relocation, mojave:        "830431b0955693be071638c3990f4b5a5e04110cb2ff69d6084dab9d7dbd4ca8"
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
