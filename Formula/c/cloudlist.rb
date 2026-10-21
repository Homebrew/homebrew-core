class Cloudlist < Formula
  desc "Tool for listing assets from multiple cloud providers"
  homepage "https://github.com/projectdiscovery/cloudlist"
  url "https://github.com/projectdiscovery/cloudlist/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "cecd9e860707139226672ad79812c0ba6b45ab4e92faaa53f3f39f8be239ebe8"
  license "MIT"
  head "https://github.com/projectdiscovery/cloudlist.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3c3aa8f4c1eba9a8b632fc44cd755cd1215bbc3768089db7927ef034079dd9c3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "775a412c5d67943d36b990f11ff70d4375caa9d3ac00c7feeffe4cefc409bcfd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "7fce75570a44ee929fae565c75e1f76d5ff1cad514837f749aaa727e7f41783e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d6d32979ebc94181bea022280b2498676c196e277e23b60dc04192947d462d48"
    sha256 cellar: :any,                 x86_64_linux:      "6ffe68a77fe94ef7db129e4a6dfdb376750892a1e08eb3c1ed8bf65d7408e202"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/cloudlist"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cloudlist -version 2>&1")

    output = shell_output bin/"cloudlist", 1
    assert_match output, "invalid provider configuration file provided"
  end
end
