class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://docs.projectdiscovery.io/tools/nuclei/overview"
  url "https://github.com/projectdiscovery/nuclei/archive/refs/tags/v3.9.0.tar.gz"
  sha256 "40b4b736071377dd11e9637c02ae956797faa6f497e8401012aaa8870d283303"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b41dc96d8b2ca3522c57b9d98fb47c6b020502bd85ddd13a9f1298969cf54cc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "17fb7a52dfe2e0ffc8bb9b1979f39a3d8f04d3a4b9a46d6c8657ff38b8063dfe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ef8abee0f71aa82c4e358a16cd7d5c1e8b7108196f239754cfe0897b1af0d4b"
    sha256 cellar: :any_skip_relocation, sonoma:        "64f20d0fcca6e3e47fed23da49f6649bd6c81f85647a7f8eead849e9d171e894"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a9dbf1706a2ea2880d793ee4702862b7f918b2dc0854992227f79effb76f9511"
    sha256 cellar: :any,                 x86_64_linux:  "f56729cb488fea489085387652fcbdbf22cbe50511429e51ec35aeab3c4e609a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/nuclei"
  end

  test do
    output = shell_output("#{bin}/nuclei -scan-all-ips -disable-update-check example.com 2>&1", 1)
    assert_match "No results found", output

    assert_match version.to_s, shell_output("#{bin}/nuclei -version 2>&1")
  end
end
