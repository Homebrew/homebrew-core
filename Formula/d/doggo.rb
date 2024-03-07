class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https://doggo.mrkaran.dev/"
  url "https://github.com/mr-karan/doggo/archive/refs/tags/v0.5.7.tar.gz"
  sha256 "3f70c40ccc9ffba539fd37c0ed8c5a1a0ab89f29815994826bfeb8e0b60e2eff"
  license "GPL-3.0-or-later"
  head "https://github.com/mr-karan/doggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a130ec12ed93478b43971278adf1b93137fdf1523cf4c12553652bf1ac7a266a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a7f416ba53a427a41437aea5511d32f2d1f40afc8e0852bdcac159b20f19299"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f589578b07a2cd153539b5eb9672bf9f02243958442990aea071723eccb23dc7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d46f069dfe24a9179991228cb481524eca1dfcea7cd95f30a7132489f7ca54ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "3642597b6ef6cdd158db30f419ec6cadea2f5c0187e2013138e16c0280df7a13"
    sha256 cellar: :any_skip_relocation, ventura:        "709c6b56a75d79db344d27a7aedcf79daa056a1ac13fd22a9b2b8201013d2a98"
    sha256 cellar: :any_skip_relocation, monterey:       "fafee53d6ccc0bedbf4689246d17b6a4888b09a7220e495747ee819900f16b06"
    sha256 cellar: :any_skip_relocation, big_sur:        "310c1d12785e93531f8e1ca8e89dc6fb2e8d56ab0aa39ba301b5d56fb9120cb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bee51250e618d009776a64eb124cd42ee8343fbae34b8d97b90e5ae10626dab1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.buildVersion=#{version}
      -X main.buildDate=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/doggo"

    zsh_completion.install "completions/doggo.zsh" => "_doggo"
    fish_completion.install "completions/doggo.fish"
  end

  test do
    answer = shell_output("#{bin}/doggo --short example.com NS @1.1.1.1")
    assert_equal "a.iana-servers.net.\nb.iana-servers.net.\n", answer

    assert_match version.to_s, shell_output("#{bin}/doggo --version")
  end
end
