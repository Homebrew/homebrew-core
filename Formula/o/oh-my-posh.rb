class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v32.1.0.tar.gz"
  sha256 "d7b6c4cda8b160970b62c703224d25ccd2b62802c8005974b88ab073e3dc66f1"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ff1ccfc75d07d2e31067508195138a4066935611e5eed45b73d4b846d729d911"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a9f192b72816bd6b27e68cc49a0b8d9094650d3efa114f171c2ef186569b6048"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1ca7100340d1323ba0e0d76f6a29cbd74f452c91c8056a8a51e4c1c3624cf8e7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "29562101a6bead4f994145a8e0f08f547885593a09035c1572a39564569985d0"
    sha256 cellar: :any,                 x86_64_linux:      "1c413e2cbb38e09c7761f3e48ab05d72358832ef6f257935f2d54aea9e6235e4"
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
