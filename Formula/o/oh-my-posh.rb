class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v33.2.0.tar.gz"
  sha256 "ddbd44c65857e87fd4dd250f327a02a8312b9d307766a0695448c094331dc8a2"
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
    manifest_sha256 "a851773ac36433759706520ad7ee8730ad657b9c487c7fbcbd5f56ee2069cd99"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "54cea633d726ecf28ca6af22a358c9b0d822f97997eeabbd4d69f4b670a6418b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6989883918f09ef9c0e4dcc3bd42e371ee34667f64cd54a843bdcd74c8aa7a9f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d88a7f5280a387e0f5aa97f33c90d4298473c7f19b035684b20760d54ba6a270"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b1428df66ec139f45933ac0494dcf1d303eb07ffd218deb79b5cf9345a6b68fc"
    sha256 cellar: :any,                 x86_64_linux:      "f717e83ad9f02d5f5720f2c7ffa33406db7d31132fd0234c413b349b09b182e5"
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
