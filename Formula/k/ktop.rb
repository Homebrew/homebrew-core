class Ktop < Formula
  desc "Top-like tool for your Kubernetes clusters"
  homepage "https://ktop.app/"
  url "https://github.com/vladimirvivien/ktop/archive/refs/tags/v0.7.0.tar.gz"
  sha256 "23c87ec4a5e60aa7c4d38b8d0aca2a8191825f2275850fc0910440544ac6517c"
  license "Apache-2.0"
  head "https://github.com/vladimirvivien/ktop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8aadc7b3483af800d8768e4701bbe214d2dd36020b46a2cd29a26ca87d08c14f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "77d8afada3236fcd0112ea9b6757b38aa5300bccf49c542ae284665fb485be3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c6ac2ad3a5598017d6e82c09b802700147ad035e4f1db0c605f03a98ed6e3e33"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "cfeecca1ff97fce8ce57564859f6943b1873764ec7b0d4f67ef9854b476717d1"
    sha256 cellar: :any,                 x86_64_linux:      "31ec54e82995406764c07f02965fcb55613e010e9708ac4d7dbfa206e854631d"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/vladimirvivien/ktop/buildinfo.Version=#{version}
      -X github.com/vladimirvivien/ktop/buildinfo.GitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    output = shell_output("#{bin}/ktop --all-namespaces 2>&1", 1)
    assert_match "connection refused", output
  end
end
