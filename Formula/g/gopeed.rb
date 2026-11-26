class Gopeed < Formula
  desc "Multi protocol download manager"
  homepage "https://gopeed.com"
  url "https://github.com/GopeedLab/gopeed/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "76b15f02749276b212f9d0305e6e073de64ce078b62894202141ab0b078cb160"
  license "GPL-3.0-or-later"
  head "https://github.com/GopeedLab/gopeed.git", branch: "main"

  bottle do
    manifest_sha256 "87c0f56c620d0b81211928b9e05b25e77e71a2d6fff4a6e45a5d7afd53dd44d6"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b2d452584b6af4bee6e5dbcd2bdf436d48b785bd885cb9d6148a24fedcd5c42d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d42ab062bb33dfc1bcfa8126d2867a44d8e7b33239bad1246af491a52cc93df2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "edb3ced7717de9bb981b4446538e1be45a2526e6f2469db7d482f5fe324dbcf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e12ce22d20548344b5f35d2c88b08a3ab3fcf60364674193478201f4ea6d22fc"
    sha256 cellar: :any,                 x86_64_linux:      "576d78e4bc7fce4bed3be947c2c9e8244aa1980739415ce83abccf15e36d0d96"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/gopeed"
  end

  test do
    output = shell_output("#{bin}/gopeed https://example.com/")
    assert_match "saving path: #{testpath}", output
    assert_match "Example Domain", (testpath/"example.com").read
  end
end
