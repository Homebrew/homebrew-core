class Presenterm < Formula
  desc "Terminal slideshow tool"
  homepage "https://github.com/mfontanini/presenterm"
  url "https://github.com/mfontanini/presenterm/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "182d827849c8ad1f2028e7b917dc578f918fc3ab17e634a35b339a143c7c6813"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/presenterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb61584425f6f382fb3ba77a6787aecde22dc41479cdfd053f7f89678e7f81d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "baaf0d9beeeeddc36fd9c749b7f33b93a35832b1af222010962f7498f2c7bc38"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55de778bd989ab1eeb193206cb44c9a1519e9c59f75ad6100cc90d4dc30d4290"
    sha256 cellar: :any_skip_relocation, sonoma:        "fead79a6ed6541a733eccee4dc5e5e9e02206f86214367d3fd9f1c9372de5d43"
    sha256 cellar: :any_skip_relocation, ventura:       "1bf4ce9813007e0b2f51e4c4f0f2c690f6a51bb06d89fa0f2fce6e533b00f881"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bb6bab037885981aabce3b8c1bd2f6d5fa55bff3dea82e782d78272ef3a8cd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bd734774309bbd65194c4df1e10f43dbaef62ca9f48be24aaddc30640a21cc9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # presenterm is a TUI application
    assert_match version.to_s, shell_output("#{bin}/presenterm --version")
  end
end
