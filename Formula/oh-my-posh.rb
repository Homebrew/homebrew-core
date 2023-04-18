class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.30.0.tar.gz"
  sha256 "93bb1761d8ab3103c38fca089fda1530628cf33393e479a683ce424755243e16"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f6f1558bfe59865fd6420bb1ac9cb361efc4e89dca6b21ad356d28169f161b73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dc27dd74adb107786bc7d7b9936c024fd050da4922d45f3ee3e71087415c761"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e265c76239f8e0a8feaae10c6a41c2ac400dc03f03b65bd88905bf51c05c7649"
    sha256 cellar: :any_skip_relocation, ventura:        "1bd0b8c10b0a03af0960fa075689bc4b47b3300fd14a2fc0494fe8c8af2cf260"
    sha256 cellar: :any_skip_relocation, monterey:       "1dab4d12956e751aa52bd79e4cb135d5ed585f421bfe4a1e34612c2e5f72b3a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "69b99de7bbfae25491f43afd1d4fc0822af165ae6d22644964bc46a0d25221b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bd3139d325bebc353560e2e4ecfcd9c866688fc7a66b8d28d494efb63105b53"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
