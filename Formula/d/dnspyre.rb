class Dnspyre < Formula
  desc "CLI tool for a high QPS DNS benchmark"
  homepage "https://tantalor93.github.io/dnspyre/"
  url "https://github.com/Tantalor93/dnspyre/archive/refs/tags/v3.12.0.tar.gz"
  sha256 "a7f227edcb297659aad5d4f235e6aa82c8990e004d69fb69b6c81d2371dc46d5"
  license "MIT"
  head "https://github.com/Tantalor93/dnspyre.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "060c75ec44e639b249ac75d745f7e64082b1a034e223d3cc816a4c7e47349a82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4eede3a1c70216af7d0e1cd6c3ee84a7f6609f5b066d273dc942048f8d5eb50a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e9ad9b1a211479227c62a3debb0d7f97f0513bf199cfa6cec65e64b27fdf3c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "328b3d91fc68bc7abc7a64047d895c58fa20d2a3d201e50d71c95dead58ae61a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0645060effaf8fbeebb4e47daad10755e193432a737ffa9ac4e2bf390385193d"
    sha256 cellar: :any,                 x86_64_linux:  "c697c9cf6201ebf0d852fbc2276b6f117b722b5ffbc81a7d9cd37f792fb4d600"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X github.com/tantalor93/dnspyre/v#{version.major}/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dnspyre --version 2>&1")

    output = shell_output("#{bin}/dnspyre example.com")
    assert_match "Using 1 hostnames", output.gsub(/\e\[[0-9;]*m/, "")
  end
end
