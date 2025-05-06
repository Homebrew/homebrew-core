class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v25.21.0.tar.gz"
  sha256 "d0823a1f954805f2837a816792822758075782572f659c65da6f3c4b4e74064d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bd82a313d5245dc59687f4b5d97fdb07ada8c6a138a3a729168715f13ed8728"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "43823fcbb30e442fa79b1dfa30022499f616d1d38891fba9c0aa384553941f90"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41cff0c873d8fd3a1363075e3fc9d39e80fc124211499aedab826187b2ee4d43"
    sha256 cellar: :any_skip_relocation, sonoma:        "f56fd37fd8c72815c2c1cb6109f6c768199140ef5bb02b3d982e9012b8bf93c5"
    sha256 cellar: :any_skip_relocation, ventura:       "11c4b02017383d9cc6f7067aeb82e275b1096bd9ecfdb0a15d9447f7d5645720"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "409cffe444dd54c1583812935e3d80293d998ed26cd6750bdc923886d81b2cc8"
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
