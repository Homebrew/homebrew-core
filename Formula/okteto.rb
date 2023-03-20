class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.13.0.tar.gz"
  sha256 "5ffbe8bf4f872038bc813264902cc845a68b7c0771ff376c4186b69c554cac48"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20bbae1636f1e50adbfc6d4e327ee0652837d338fba06884e1842c16244112da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37a903c5f7e062e2035d752633d8ca5a76562a1bb9fb208652957716d63deece"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4aa27c9664d6c13226edee6a0feb7da0afb535f14e6aa63955adbd67946a56b"
    sha256 cellar: :any_skip_relocation, ventura:        "0c4f185ef9382d274c4b01dce79207d67260d02e1017b30f897dc806d63494ac"
    sha256 cellar: :any_skip_relocation, monterey:       "200f7fde9c9d7a45c64432c2602a54f6e71241db458592dd8c81ed69dc5d8e67"
    sha256 cellar: :any_skip_relocation, big_sur:        "936e5eec5cab3777a7c9fbb40f7f4dd8c03c7fb1a56ab788c2d976bb6511da27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c242fe5c57ee2283eb30b5a70acb07adffa1fecb065aac9baed5de5732f0d20b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
