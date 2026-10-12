class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v31.8.0.tar.gz"
  sha256 "b4f7df1413234c411b3776030265f9bd4f1f1843557f45bf026da7056f0ae990"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1a16cf85bf9140a5d1891b5e7949c4b1aa177f774a738c1a702408812034edba"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3aea3e0f405508997399b1e1c77dcd8f42838f510b47a054463f75058ac564d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2b8e993fc15c46060850431cd44bbac0b330ae7bbb69fa864bc0997c5c5f65ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "af29cfbc09e2ff05fbf7cd095633ac1e141ab50c2e049b4ef966a107744412f6"
    sha256 cellar: :any,                 x86_64_linux:      "846c81b246198231a70832ac0e9287d5ff732b025d92d976c7d8a3239b9fccef"
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
