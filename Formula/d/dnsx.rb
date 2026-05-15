class Dnsx < Formula
  desc "DNS query and resolution tool"
  homepage "https://github.com/projectdiscovery/dnsx"
  url "https://github.com/projectdiscovery/dnsx/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "5de84e732cf5c8b31f481e9a98fc22025f402d3624a6b9a74c29bddacae155a1"
  license "MIT"
  head "https://github.com/projectdiscovery/dnsx.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caf53bc5bb0559b1e7895cec2dbe9dcbe8bc996ca25a89106bba5a9d51814c7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f0761c337a0d29db5fb9b59318119b9913002d9b119502e01e3d191d0822015"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6d20c67030e1428b057292dfc9df0405bac77232d00cb6451fdb7d81b08c4d6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4204057bfa091927e1de824f13507132bd2ce75ddeb4013ff5f300a0e6b9443a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f22ec765a54e1d02074dbaa73b7659aca259a3d645b01c75e1dbd4697f00351f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97dbf04b904989d2ffa04891a00bd196eedbf28e928c89bbf9bf788ce2928bd7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/dnsx"
  end

  test do
    (testpath/"domains.txt").write "docs.brew.sh"
    expected_output = "docs.brew.sh [CNAME] [homebrew.github.io]"
    assert_equal expected_output,
      shell_output("#{bin}/dnsx -no-color -silent -l #{testpath}/domains.txt -cname -resp").strip
  end
end
