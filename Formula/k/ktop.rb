class Ktop < Formula
  desc "Top-like tool for your Kubernetes clusters"
  homepage "https://ktop.app/"
  url "https://github.com/vladimirvivien/ktop/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "155d9bbe6d14e581d0679ccf042dd8dee6993a8af8a33a47febd0965836dcec7"
  license "Apache-2.0"
  head "https://github.com/vladimirvivien/ktop.git", branch: "main"

  bottle do
    manifest_sha256 "150e1e667d1ec2caa7c035c7d27d8097eebb9bbee904a0cbf2dc7f0c2718ed3a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4c139dfdedc2b4f65d8e9f7c50fe09e9e83ce7ad9ff9a909d12f8fbe6eb6f75e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "80ae4512be9a5a5cca7fab59c5f842236ba3c11265a0e4cf64ddb21ffbb08484"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6b21e86afc77fae325101506322fdf901ae6cfaca3dfb3d291e96d27b0c96c41"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fdb91dc6a29c21d14cff64f924f70305913c53ab1073b15ff28bd5f1bf359c05"
    sha256 cellar: :any,                 x86_64_linux:      "ca58fc96db41e3b700b16731d40dc598981ec0ca82378a1df3ed69e4eb7c8005"
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
    output = shell_output("#{bin}/ktop --all-namespaces 2>&1", 3)
    assert_match "connection refused", output
  end
end
