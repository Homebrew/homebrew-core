class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://github.com/ddddddO/gtree/archive/refs/tags/v1.11.8.tar.gz"
  sha256 "69f83ba138b3ccaec18f82554b95a7a8a565112a101637f9ae107370ae3fa596"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4dccf001a0d1182f86d901359bf1ad57104b16f53d4b06027024bb19b84e1ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e63527c33c0b0845fbd1d6e5df50548b105c155649eab405be617816179617a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e63527c33c0b0845fbd1d6e5df50548b105c155649eab405be617816179617a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0e63527c33c0b0845fbd1d6e5df50548b105c155649eab405be617816179617a"
    sha256 cellar: :any_skip_relocation, sonoma:        "abadbd13b16b66a8a2f11222aac159540b2569fad141710ec755271d6d65054d"
    sha256 cellar: :any_skip_relocation, ventura:       "abadbd13b16b66a8a2f11222aac159540b2569fad141710ec755271d6d65054d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "262b2e093fcacfb050d46b11bb480a69b23eb2a3ed1d2eed3cc08ed552c40623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0083365506a1a29c7354c8c26f0422d2b39c5cdba274a4f7e35fcb912e220bbb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gtree"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gtree version")

    assert_match "testdata", shell_output("#{bin}/gtree template")
  end
end
