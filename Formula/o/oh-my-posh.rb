class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v25.16.0.tar.gz"
  sha256 "5ffd7afafa824732bc16a867eff0d90b1a46ab736e1d3be855ff0d98931cdfdc"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47b7cd5e75cfe2c01baee1d40acb32615c55dbd4f5f26d7c4af425efd7a6cb57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9957ac901b5b1988e5550778781e7dc365976c16151dc71831d2c9aa7e7a35c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07a4611b6b3dbd20c8bb68fd805a25ab6dee71abc9afcdfcd26282a6cc80a000"
    sha256 cellar: :any_skip_relocation, sonoma:        "9fb8dc0f213649e01199875093abbef8a72d57c68707c325a0e2a4b5a29acdd5"
    sha256 cellar: :any_skip_relocation, ventura:       "c04ee30a60acb22769b54a039811b60fb60b32f34d918bbe87a55f9051a840b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "45b282f290d71e0c8b8cee17f69923caf287cf488d4ebcd29e3308f47295e0f3"
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
    assert_match "Oh My Posh", shell_output("#{bin}/oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
  end
end
