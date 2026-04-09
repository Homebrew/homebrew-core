class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.9.4.tar.gz"
  sha256 "a200cb1c03c01f221cb6545c0bcfe9a9b3af9702d7b8c6b97dcab93d19ac1755"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d42bfb5b431a6715b028b3a775de12c96865f27fdaeb2263df624d501aed296"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "72bded46417dda37b2b1a41c2d7cf732b6e5e5d9b582ac0ad8ec5e36c2378ae7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3e905258e95358f29b9748e036788b886091ac6563e6404d4afe927c030bc07"
    sha256 cellar: :any_skip_relocation, sonoma:        "959fcf72765fed2b0ec059fdf2f85eeb2eb6a0efe02461f15161e0ca854aeb81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5299419a964268cd0638c0169df7d97a1cafc09904bc614b36a3b6d3aedf1b84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8c23a54f11c31a1f414566e78f0b26820ec89cbf6ae702e15d5db04e876caf3b"
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
