class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.0.4.tar.gz"
  sha256 "bf3b904f1430a23ad7fbe6b6a55b36bca3b048c161c51f02494f1411af3de0b2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "811d02f353a7a376d900e895bb0203cc7708a06f959d5a2b7191ee01a81c1794"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09cda0ca448b6ed0bd11fd24606d748e6464aed4372e184093250549d6b0d756"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5f7ec8458328f34abdeb67237d24eaa5980bb153319a440020db3c01169c8690"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9402eef33bb3ea47671adc4dd0c5a06f656810d27da938c9bddab1d5e399185"
    sha256 cellar: :any_skip_relocation, ventura:       "5c63d19cf361679661c2793c0f1039743d0743e99d5936d674538d2463194bf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e7876df706c2862b9c0ff4d59c05d8b3b6d9008328aa7b7aed6c04c2ac191adb"
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
    assert_match "init.#{version}.default.sh", shell_output("#{bin}/oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
  end
end
