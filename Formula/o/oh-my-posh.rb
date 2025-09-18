class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.23.6.tar.gz"
  sha256 "fd6ccb9628e573f07d3aedd7f2eb2597f7bcf247174ed72c857bc1e460e494bc"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f0bf8dc9683424c51cddcc8c7bee70df65fb6ce61070e876ed0bde4debb2f293"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e227060808d0aeb60099ef68219083740e5653ce65eb05f938b077067d4eaad3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7800932e9e04feaf348c0516c914ae8c028ed3f87b9e7b4b6b377db167b69680"
    sha256 cellar: :any_skip_relocation, sonoma:        "b7048ac8f963da08ee82844edce1b1c4c896dec3543fac2a4f11af72aede1640"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b1fd778d115ea93bf92f009c7e221fa192a24a2205ae3376aa41cf779c4e97d"
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
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end
