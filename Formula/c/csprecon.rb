class Csprecon < Formula
  desc "Discover new target domains using Content Security Policy"
  homepage "https://edoardottt.com/"
  url "https://github.com/edoardottt/csprecon/archive/refs/tags/v0.4.7.tar.gz"
  sha256 "93f448d1c8b9f4b45e066fb84665410f554fc815cad75c9cb8aa1b0df2cceab5"
  license "MIT"
  head "https://github.com/edoardottt/csprecon.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9159861259e33c7119caf64fea93917082f65865046137e3344b68706cf199b6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e5ba92dfd06ad1e654c7c67d6247ca151d8eac8339da43e40cdf64297e4fdc0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "dc2137259f0cf7ef65d465d9cab3317b7971e0bb888031c5f26ef2123a8a2ffb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b50c09be1d471d1ca93b698df46bffe9eec0acdabfd4c5f20b0f2e4da5527e67"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ad668b02c5b5c5c906fdad9b55c2d98fb29a77c339ca583fe9df2d9ad680c96d"
    sha256 cellar: :any,                 x86_64_linux:      "d4db4557167efb9404980eea98b53ad21f038eee6901a977115a8c9a0daeddf3"
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
