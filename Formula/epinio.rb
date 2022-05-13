class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "25eeb7ac7f12fcb9f20845d8f340ab74dad24e467761f9658aaa3f864319c036"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d06c1f2d6ba97932c384523524156c3ef3a85233136929cceeee6af5f8214a8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4e39f6c06d93d6dc04bfeb9b9edb32e22e8b2b35400366ca4eac66080cf77bd"
    sha256 cellar: :any_skip_relocation, monterey:       "bb5ec09403d1bae1f7c735ae1421a971ea36f66adad487f658168c0d36cbef9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab564a1321193caf8ae2c811634076db7b20c2d75be4bea442b6e0569520fb10"
    sha256 cellar: :any_skip_relocation, catalina:       "4884df241229b354bee98edb7f60169c9f253a14c077641cd6ae27579d9cb27b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af8db289bd0578f756eff57d1a120d260e2e62d4c7d087f3ed7debc7f236bc80"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=#{version}")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: #{version}", output

    output = shell_output("#{bin}/epinio settings update 2>&1", 255)
    assert_match "failed to get kube config", output
    assert_match "no configuration has been provided", output
  end
end
