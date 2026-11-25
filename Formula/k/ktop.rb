class Ktop < Formula
  desc "Top-like tool for your Kubernetes clusters"
  homepage "https://ktop.app/"
  url "https://github.com/vladimirvivien/ktop/archive/refs/tags/v0.7.8.tar.gz"
  sha256 "a21af0a325ed0183ae099eb8586e19a4a325254faa02b28e1e052e5e59b6ff84"
  license "Apache-2.0"
  head "https://github.com/vladimirvivien/ktop.git", branch: "main"

  bottle do
    manifest_sha256 "2da2e21a90ebeaabb80f396566dd6a87b4a312afbcfc17d3a1cca94f254fe425"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "68d01180eccdcbf629345f6a12aa1a56176f3cc7f056237de79f218594a0434e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "277eece029519f8d04b17ab9b6c41a4857f39c418423883e5786c2f74c7a5033"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e6d1831f157e37bcde009baa136be85dacf5687ef497e1656280feb15943a618"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f05c0900933ebc59094c89ab68ace5ed8655fdf9d732bc8fdc12dc4c2e5a8f27"
    sha256 cellar: :any,                 x86_64_linux:      "97752f3eb23682dbec1638e536b787679ac3baab67d2ff770056e3409037bcc2"
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
