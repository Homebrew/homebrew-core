class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v23.6.6.tar.gz"
  sha256 "5c6024e682017e67490c3df33f16789c5fd36f79a707282a9bb08937c7724ed2"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23a4a4ee26ec5dcf199e05733e12ac0e578c9ce7fee84ef8ee8cfa58b47031d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f2cdde8ec5fc9c0984078c330b5b6731d9cf453bf03a63b7ef9c385ab9351df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02c69c8182b7465212557e29afca8978c00d5b2bbd65697de4c160b9d9fbed9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d225d43c71b86409f0c83c8b881b87fc639c95c645104780f5c456c9ce5390ef"
    sha256 cellar: :any_skip_relocation, ventura:        "d25a21776eafe3eec112e51308e2194bd57511f0210a48a4b30b3ccd05fd4113"
    sha256 cellar: :any_skip_relocation, monterey:       "970d0c696ffa9643be9ed84ff9b7fd0de1aa14b02bd8a527374df118b0b24dff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41c4e9b611dc29c1d075542ea6baa6b1c41c4b0d8578a415a08a1a42b06a7365"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
