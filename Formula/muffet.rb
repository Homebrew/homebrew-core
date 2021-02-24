class Muffet < Formula
  desc "Fast website link checker in Go"
  homepage "https://github.com/raviqqe/muffet"
  url "https://github.com/raviqqe/muffet/archive/v2.4.0.tar.gz"
  sha256 "31a894186a0452c4bbf281c48950146c3191cfa3dc73596696f9525be245c320"
  license "MIT"
  head "https://github.com/raviqqe/muffet.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bb6a1f79fe2c70c8b54f5606f157338f508f5b8454e8b8f025a5921a4dbf9400"
    sha256 cellar: :any_skip_relocation, big_sur:       "dc8eaca3727e3f44cd4782473933a291d124e1fdfac42ecfa6fcc09ee8330d3e"
    sha256 cellar: :any_skip_relocation, catalina:      "6b400e2c66b268040095257db15819b093956816f2b7763d13ad95c87c34db66"
    sha256 cellar: :any_skip_relocation, mojave:        "7969b64e9a823734c1c96f0356302bd6edc7a740bcdf8d75fa97a7a8bdb3bf60"
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
