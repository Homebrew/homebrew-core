class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v27.0.0.tar.gz"
  sha256 "5defa664b63befb3e2371dfd3d199f07709b615fc23300a05baa256013c2ede0"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "563d10eae32bbc9ba41c3465d4aa0170b885c022bedb06fa87c521e3b4aeeef0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a587cea3b84da7860c79d33426f0e823a845ad176ef996af3da5fd357289a4a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a61812bc47691ed47eb71d97b61dd99f14a68cc3a591601f6896d8b6b86dbcf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8401d3d98344ee01734922766bcd23efa0da73fe65c1994a448be79fc7ebbb61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ac851710bd9fe11fa0a727f4d751f2f6092b8827e617d1e90d9e2ac41d477db"
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
