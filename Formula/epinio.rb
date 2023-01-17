class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "cb8e38635959d27a2aaecb99b69cb9eb45de3b772571786065b446d07371e26f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e49d9d681b1ff94e6a8f04da22d91487b03a02f9e3ed5f8c29274002a1b701a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cac8abcd74d7bfb753aa10b6da2a9947bb1ca835a48862342b9dbe52321bf22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4932790489a43dce89c54f31191e117d2bf06c0a2f2b69d35daeb4331745709"
    sha256 cellar: :any_skip_relocation, ventura:        "79881657034c31dab4131927283fde4eb09261514975d8b685f05b2909da079f"
    sha256 cellar: :any_skip_relocation, monterey:       "f5ef9a94209fe5205aa0f52261be6376d18f1d2d812fa2cc3b48c5355b40768b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e70eccce938d9ddbb9c40d9dcb0c322f502084a4289f857831626115b626970a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4c8d3f941f0a73283e0d6efae25e79c2ab73dc5cc1bb543fb29016b0348a79a9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=#{version}")

    generate_completions_from_executable(bin/"epinio", "completion")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: #{version}", output

    output = shell_output("#{bin}/epinio settings update-ca 2>&1")
    assert_match "failed to get kube config", output
    assert_match "no configuration has been provided", output
  end
end
