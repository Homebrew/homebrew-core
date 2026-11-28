class Labctl < Formula
  desc "CLI tool for interacting with iximiuz labs and playgrounds"
  homepage "https://labs.iximiuz.com/playgrounds"
  url "https://github.com/iximiuz/labctl/archive/refs/tags/v0.1.117.tar.gz"
  sha256 "5c35a7398be6d60594932e75185e3cfa4c7285b225c8644dc050a61df25c7c9b"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "8d8f87b3d0082d1f89ad424cb1cccff80f4834aab1e303456d5d46d8e782baf6"
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
