class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.116.tar.gz"
  sha256 "6398ff8ff6f67207a3709f458abc21ccfb25c782216305f6f1a2e7e79985e17d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0f1f0d785d5d76089849e9f0f552aebdab09bba44a6bd0790a1102c65c02490e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0f1f0d785d5d76089849e9f0f552aebdab09bba44a6bd0790a1102c65c02490e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0f1f0d785d5d76089849e9f0f552aebdab09bba44a6bd0790a1102c65c02490e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b7c5d7bbce2083c0cabcce4a520628aaf2626afb1184136e24779d29411ceb2e"
    sha256 cellar: :any,                 x86_64_linux:      "37319fa84cbcb84bede55c1bc90ad6e31072b5c1a7e8ef47fc998cb9845d3cad"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/labctl --version")

    assert_match "Not logged in.", shell_output("#{bin}/labctl auth whoami 2>&1")
    assert_match "authentication required.", shell_output("#{bin}/labctl playground list 2>&1", 1)
  end
end
