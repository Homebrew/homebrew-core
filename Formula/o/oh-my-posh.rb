class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v31.9.1.tar.gz"
  sha256 "6764e5db3623173def3a7f1ba37a7a4c70cfed53484f7ea2528082888183bbac"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c7e4801467ae5264914585f16688d319496866af288811b211ee50aec72b6bc3"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "84ac0196f703f781e15c3110e3a3c91cb93ffd8bb5c526035886f6f4f9e9841c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8ea057dd7e7b3b2a50d19cf96f415107a970c499ad0c3768a5e4f2810375998c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "77ca6e9e70d57c39d7ea1bb94c71bb47d83fd7b12176a6d9fb7dc177c3db94ce"
    sha256 cellar: :any,                 x86_64_linux:      "c45e556aa88ed7de119362d21819495f6cf6f80a17805481916e8cbfb0536423"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download", "-C", "src"
  end

  def install
    ldflags = %W[
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
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end
