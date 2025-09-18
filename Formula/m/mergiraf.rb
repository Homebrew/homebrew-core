class Mergiraf < Formula
  desc "Syntax-aware git merge driver"
  homepage "https://mergiraf.org"
  url "https://codeberg.org/mergiraf/mergiraf/archive/v0.15.0.tar.gz"
  sha256 "75f553935df38dd84679727fe3b3232d54ed4a9fe6ca214e3fd54ac714d0fae3"
  license "GPL-3.0-only"
  head "https://codeberg.org/mergiraf/mergiraf.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e5c707523be55ef45945f624325043303cee8eb7450b7f3fd7284934c9d67423"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1db32935fdbc41b2c3b0cac96230588948f9931bf7fbce8e25d4a8a6131c9858"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0463ff64b10fbd79a9271a8dce8b75b126c33251151f87d964d8303566288b46"
    sha256 cellar: :any_skip_relocation, sonoma:        "82b85bb2476b9a117d493e78481f9ca1c6e9ed7eb0b1103175372bae490d6aaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "85c3214034957249a281375b050e42af0439d17701629804ada0642bc58e740d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b0b9ea5f2c8e6ad67b14807265a767e3f6478bea3454cf9111f5e51ac30fc35"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mergiraf -V")

    assert_match "YAML (*.yml, *.yaml)", shell_output("#{bin}/mergiraf languages")
  end
end
