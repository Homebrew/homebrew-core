class Ktop < Formula
  desc "Top-like tool for your Kubernetes clusters"
  homepage "https://ktop.app/"
  url "https://github.com/vladimirvivien/ktop/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "7679e6dd3fbcd784d44b8d89c296e4aef0bd1187708c3499403d7ff9a586824a"
  license "Apache-2.0"
  head "https://github.com/vladimirvivien/ktop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "20ea1016583331f895c0a8ec835071b3771bf41779d3ddb2ae666d790759834c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2ff20a197633a6b5fb627307bd45027488bd3be77dca56eeb17174d9c1ef0b93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cdaa2aa97b206f97517063d4576b99f6285dba6e1b6f38ef8e7dddc65bb414e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f2982ed9025c86d2b2d7fd9e2ca99f0d1dd4586a70813aa8b9b2e6d342bc5dbe"
    sha256 cellar: :any,                 x86_64_linux:      "229522d759f55d700ef08b438f298859bbe541cb1116ca643ed2d92b695f4cc4"
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
