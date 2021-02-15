class GhzWeb < Formula
  desc "Web interface for ghz"
  homepage "https://ghz.sh"
  url "https://github.com/bojand/ghz/archive/v0.92.0.tar.gz"
  sha256 "c2e835ddc61092602d5032789dcb630a564d0c8f804911cdb8cf95c57587466e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fe991e38587133513f95005d3383c7434f6eb831075089d99662129240af50cf"
    sha256 cellar: :any_skip_relocation, big_sur:       "db802eaa46e4a7a0f3f4158eb476b6283c383232a3527695db38d936b8178fb4"
    sha256 cellar: :any_skip_relocation, catalina:      "e4e6b4baa7acbfcebee2fac97f6ab51610716368ec6bae585de7423625579d84"
    sha256 cellar: :any_skip_relocation, mojave:        "8d63fc56e1b98be8b29391cb009e9fab427eb245576c09d85922190f017a8e43"
  end

  depends_on "go" => :build
  depends_on xcode: :build

  def install
    ENV["CGO_ENABLED"] = "1"
    system "go", "build",
      "-ldflags", "-s -w -X main.version=#{version}",
      *std_go_args,
      "cmd/ghz-web/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghz-web -v 2>&1")
    port = free_port
    ENV["GHZ_SERVER_PORT"] = port.to_s
    fork do
      exec "#{bin}/ghz-web"
    end
    sleep 1
    cmd = "curl -sIm3 -XGET http://localhost:#{port}/"
    assert_match /200 OK/m, shell_output(cmd)
  end
end
