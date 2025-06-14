class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v26.8.0.tar.gz"
  sha256 "b89c68d7b933e0c281d51c9983a4837881db26dd1d5e7afbe958dd4666b3824d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caeaa2bbb2d0a928d3f96152366def4d297fa4da3f36c847647dec84703b2133"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b0b3922e700093e63afd56f02f4fcc7459a0e9c9b097d7f37ca4eb5d82a4fde"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c114b0bcf4958234af15b1774518d20c9275c3a187d12fc8d4dbef4af1b75ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "d769b80e5e59f331b7356cb4099cce7cc48e917c9ef9446b44bc044fc1969e19"
    sha256 cellar: :any_skip_relocation, ventura:       "144d4d602448dac5899cd278e3e79a398ad3cb5b9e39b1a44ce6eeb8fcfd8a7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdbcad03ad2f0e0b79348631a4250dbff315f4d1989d5a3ee970fae8c023c684"
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
    assert_match(%r{.cache/oh-my-posh/init\.#{version}\.default\.\d+\.sh}, output)
  end
end
