class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v33.4.1.tar.gz"
  sha256 "0fe906adbd0c2f31a2b81df854529aa59e71f3f33a479e41638ca00f67e442bd"
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
    manifest_sha256 "cf5284d43cadfc85489b9a9318ad71c11aa1e0535eb8f551117639b320555804"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e73cb38e6cfeaddf81f5f62222d263795ba8cd68aa0023a98763058c7576df60"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6c8d29070eb74767ac9bc44228663186bff962f5d61e46b46b7eb18ce6e9e8ac"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "27474ba192513be0bb551d5f0e280b732e85392076e9578d2b3a24ebb17842eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d0f6d008dd6dc272f32e18a14c2012a1d77f828f765a462f29165110ec6830f8"
    sha256 cellar: :any,                 x86_64_linux:      "c3574b3977a5eda94f111e72abc9b67256f9e4fc2450b95f75b3f43ed24b0f95"
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
