class Goread < Formula
  desc "RSS/Atom feeds in the terminal"
  homepage "https://github.com/TypicalAM/goread"
  url "https://github.com/TypicalAM/goread/archive/refs/tags/v1.6.5.tar.gz"
  sha256 "f60714b88de775ddf4198f86cd80da88c72acb36f59ff9b6484fe0a7680ebdad"
  license "GPL-3.0-or-later"
  head "https://github.com/TypicalAM/goread.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1856b4b32b9ef42a22a2ccdeedb8b29e8160cc836c43c46bb7e6a5593f68b800"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d3a8c15cc058d98320680bbaf5e58dc779873a8fd526729704f43958e9fa33f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3d40cdc7664bd7790309556a17976cbbd77484431eae9303e118638af2be1c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a84726926b5116f9bf7c2e0dc7230dcaf787d56284254b8fbbc2792f6bee2742"
    sha256 cellar: :any_skip_relocation, sonoma:         "be525b39206cfe8fccb5f97a4839e2436d5bbaf92059e2979b1a6c4cc3a6ab32"
    sha256 cellar: :any_skip_relocation, ventura:        "8ee5b6843d8e83fad5fca0da7d0cdd228f3247d347aa65864de74b6df25ffbf7"
    sha256 cellar: :any_skip_relocation, monterey:       "9b151438526bcc964172ccacd02322c636876577a7972e3ac1e2c3a6b0902e49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f301ef674a9296b6e916bba05b7dae5dac3165db6065a20e3384ddc379bdeefd"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/goread --test_colors")
    assert_match "A table of all the colors", output

    assert_match version.to_s, shell_output("#{bin}/goread --version")
  end
end
