class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.28.0.tar.gz"
  sha256 "e0ca6ce14f7a148f110999f13f0a82a886e3c07ef0aeaf9e5a6e0cfdb67e47c7"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8ceefe74fdb81c4bed76b42cba54b6057a5489ba4944561df2e3dc203001b51d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85901ebd62b84f069e1628213fcea2ac9a5dc8ad30d13b6e56427b0572737012"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a6b3cdc5162b1b1e6729ab052f9a696e1c0b3cbde6b512af8c225b4150e8b56"
    sha256 cellar: :any_skip_relocation, sonoma:         "6252c56c71b4efd5832a0d6be7ee4747953fdef0c0308891118a30315be71550"
    sha256 cellar: :any_skip_relocation, ventura:        "900c128a3bc31b2da1afe64152f6a8e43f5350c72d65c9eca07c4b0bb9fb201e"
    sha256 cellar: :any_skip_relocation, monterey:       "bb26c2bc6800426c9ead9934409abcc8c2248ef4762a3ad6f238ac97e62ea304"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5d5acc391bd5320cbec2a6f22f8b7d82ae053fcb66ba6d981ee1c71739ae1c5"
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
