class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "17e527fc18ff25c590ff8790c32322e9c9c5e036ccf279ca2ed63be870889182"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6877a49964fc1e5255cb4900763d2038bf34cde552536c412dff49d677b35751"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6877a49964fc1e5255cb4900763d2038bf34cde552536c412dff49d677b35751"
    sha256 cellar: :any_skip_relocation, monterey:       "7d4108c488ed2b8e281e843579c0f74f47edc5c767f3335e39bc55e6dccf5fb5"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d4108c488ed2b8e281e843579c0f74f47edc5c767f3335e39bc55e6dccf5fb5"
    sha256 cellar: :any_skip_relocation, catalina:       "7d4108c488ed2b8e281e843579c0f74f47edc5c767f3335e39bc55e6dccf5fb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5383d876bf01755e498fbae2d075dcb58745abbf3b24ba53ed1332dbe393fc5"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
