class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v33.0.0.tar.gz"
  sha256 "0c1487ee7f04d3ad7641463334622c2e2de98439d134702380f2baff2bc616f7"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "544f9c3cdb4eae7e07b50af3de5a5e85b05a6b7cdc906938fc1324fe002786cd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ec7d139e74bc13738016349473e97419aa3c549e5e0f0cf185316545f7a0460f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "faf4a21562dbf692619462cb97a20f5efdfd3fc24ab66104ca5aaecfefbefb71"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2e8fd80038508be425d0f6c7baf481adf06b2d77240dd265bc1147a6eba5fa96"
    sha256 cellar: :any,                 x86_64_linux:      "91f553ed9918c3f4bd5fd9ca48f304d96a88c889cecdee6563e4c9905664585b"
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
