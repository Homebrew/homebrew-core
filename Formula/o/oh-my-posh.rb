class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.26.1.tar.gz"
  sha256 "30a7bd55ee11693e12be2ba4ad36e670aa353f4f2cc7a02597a0ac01fa2f3058"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5ce38af0026a621c62e52c793b5b20c4767aad71c242ff881344f7c1db1a2673"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18a5add129e4ec0a11b88f3d2607f80fc7a573dfb50d465b2910179879c2e3bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bce03887425172a117fe8b29a44e891988abddbe2ca32fce23e554cae62a3511"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f4143cd3a6f7c292bc63d7ff8db4f1ec95e4030601a048792cc51d508e803bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c42f5ac45c244b1309886278137efa493ea9e35e12b55e1ab1653ffe0c5b495"
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
