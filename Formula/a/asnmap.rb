class Asnmap < Formula
  desc "Quickly map organization network ranges using ASN information"
  homepage "https://github.com/projectdiscovery/asnmap"
  url "https://github.com/projectdiscovery/asnmap/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "3d48657278a1f1fa27528e66d5cf4bcb6f3ee7ce26a518fcaf6ce9a9c9a8e317"
  license "MIT"
  head "https://github.com/projectdiscovery/asnmap.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "6d30ae986746962385b61472a49d0d9d5ded178c4ab0fd02d45146d9d9514b83"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b2f106b6ccfbce290cf32265b1198f1056b9622cd2fcbdb7e6fe146098bb98da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "676a3e1e9acbcf36042c305254cba864a8f122f206761a689667347c17c9c4a3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7694fa2c90ce2daff499a549faa0af0997e9cc89550d12f3a457ae13cd06cee7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "044d56aeee6424bf5f72c668a53b72a6357259d6a9d4a384dc18fb1b61ba759b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f859f48ef91d69fe448c33284462f5802177d73619e39dfcc4894ad359212273"
    sha256 cellar: :any_skip_relocation, ventura:        "5b3c2c268b3a78ba6aa1459dda4798c7ecba402acacc5a1ab64d9b0d0e7e6736"
    sha256 cellar: :any_skip_relocation, monterey:       "01cff6b7dea711d6716674b008cc915b7d86c40134e8378e2d964f3421d6ee3c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9028f3436f84bf3c7b7310c7cb0f7c1230601805db6b6a6152dd72fd4af5818f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cc586b3ac93d7c6d675338f46ec034d1c0d20e3f46306bbd56c7f964b8f0fec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/asnmap"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/asnmap -version 2>&1")

    # Skip linux CI test as test not working there
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # need API key for IP lookup test, thus just run empty binary test
    assert_match "no input defined", shell_output("#{bin}/asnmap 2>&1", 1)
  end
end
