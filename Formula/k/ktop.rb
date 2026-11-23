class Ktop < Formula
  desc "Top-like tool for your Kubernetes clusters"
  homepage "https://ktop.app/"
  url "https://github.com/vladimirvivien/ktop/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "e5ef61e0d45628295d994464ba732403e006d884a8415c2b234cb6bd16e5f0a7"
  license "Apache-2.0"
  head "https://github.com/vladimirvivien/ktop.git", branch: "main"

  bottle do
    manifest_sha256 "25d0d02c9682051d13377a8a8fdd04448909824eb6febb2f5c312b6126e1474b"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c0129c1679649fb49f9cfece821c5245ddac0ef27a38d6d6dd5f63811d0a63d8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "effa8db2912b7c29969e132ded94e68cd48db95726d95a079fac9d5b7f3c6bbd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c50bcbb4434bd869418f7d07742380a439cd8838280527d564a4f6ec59d85bc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a53450fb6a94424c19ca4289e751a7c1eebb828437a194ce2f2bfe1e74449c4a"
    sha256 cellar: :any,                 x86_64_linux:      "554b372a851fa077cbbe1ae657d2da167cbbdd9f3f1b3693255db9bf6af4779b"
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
