class Csprecon < Formula
  desc "Discover new target domains using Content Security Policy"
  homepage "https://edoardottt.com/"
  url "https://github.com/edoardottt/csprecon/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "d5ac261e9afa4a5d84bcacf8583fbbe9e7ced73b4de9f40558b6e046d7e1f258"
  license "MIT"
  head "https://github.com/edoardottt/csprecon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9f4bbd561d08266d3e7bacfbc8ade81aa238217d2c40eef108acf4ccc8aa5e44"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "abaadc597e0e78a010594e72ec35f6881f365247e3171cc03b880672cde2a08d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "15d3b4918b2e69a607ae6368ab81e9745db0da85a7ea986204424995ee9a2b76"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "feaa83e3128522214ce6baf0c59208bc6065b1264e569264d212f70636539ae5"
    sha256 cellar: :any,                 x86_64_linux:      "893cae38a997822d46b1a1243a68e4ca9f699d04e21d94f435f3ccb5be87c3ae"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/csprecon"
  end

  test do
    output = shell_output("#{bin}/csprecon -u https://brew.sh")
    assert_match "avatars.githubusercontent.com", output
  end
end
