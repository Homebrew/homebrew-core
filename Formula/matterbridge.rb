class Matterbridge < Formula
  desc "Protocol bridge for multiple chat platforms"
  homepage "https://github.com/42wim/matterbridge"
  url "https://github.com/42wim/matterbridge/archive/v1.23.2.tar.gz"
  sha256 "5f00556b89855db7ce171c91552f51de1d053e463b8c858049a872fadd5c22a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8f8d98ab840fc86ab6bdfcb9a680d133690afea8ca4302fd6b3c339019b469f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1e8132fc4300ea7eb8d10bf32e2f421e8b61aff1ff1eb89fa399d8732d3953f"
    sha256 cellar: :any_skip_relocation, monterey:       "673c4d9547eabce6abe1844fdbf58097ce1761bb326a3de8fcd699c6f5ba4054"
    sha256 cellar: :any_skip_relocation, big_sur:        "56c14f672c316a1710e8438ea2b8ebf3b1f5510acf1eb64c2718a6ad9a1bd73f"
    sha256 cellar: :any_skip_relocation, catalina:       "ec8d0ba76fded16e615b5c3e1a484e8223dda43d122c76f24117cbe147c08b72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0ffbac30e1593eedec4650a3b5cf73a46f14c975230fa3dc970e19566839898"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    touch testpath/"test.toml"
    assert_match "no [[gateway]] configured", shell_output("#{bin}/matterbridge -conf test.toml 2>&1", 1)
  end
end
