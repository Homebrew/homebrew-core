class Gmailctl < Formula
  desc "Declarative configuration for Gmail filters"
  homepage "https://github.com/mbrt/gmailctl"
  url "https://github.com/mbrt/gmailctl/archive/v0.9.0.tar.gz"
  sha256 "1b4d04c0fa46990231565cb743d3b9aba2011501322c224a96bec747003c35e1"
  license "MIT"
  head "https://github.com/mbrt/gmailctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ca176f471c5358025d9fcdc158a732e9e64232e5c2f7aaab53efbbb846920e57"
    sha256 cellar: :any_skip_relocation, big_sur:       "e72f9006fd0c10ef79ecd4c2f875d1ee984d6ee40a6a717894b29cae9d3324fb"
    sha256 cellar: :any_skip_relocation, catalina:      "e191cdefb1f75f799f610aeaadd454c27d3aa90527d3bbf69ee804ca5c94dfa8"
    sha256 cellar: :any_skip_relocation, mojave:        "57d9dc005423a078971fd79d5c2382c07f17b4536a445d571cef47d025d28ffb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58ce36e464f9c0d38c8bba1c2bb46bbdcc1e8bb848808da06b04a35007e763e1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "cmd/gmailctl/main.go"
    pkgshare.install ["default-config.jsonnet", "gmailctl.libsonnet"]
  end

  test do
    cp pkgshare/"default-config.jsonnet", testpath
    cp pkgshare/"gmailctl.libsonnet", testpath

    assert_includes shell_output("#{bin}/gmailctl init --config #{testpath} 2>&1"),
      "The credentials are not initialized"
  end
end
