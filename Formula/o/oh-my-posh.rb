class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v24.19.0.tar.gz"
  sha256 "56ab165eb166d4cb6ca3bb21d9f262c27efd727778b1359c0794980d8ad87478"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b94e151098cfac8bf9000177d6b047f6122d464a600b615ecff151d25c1aa25a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7861dd068a1875d2838edfdc24e5fb034952e04d54345801d78b2d0291a839d4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f88b50ff494f4c22e75e0783a19e0f7bd1cddb080651351ddab6195696583d34"
    sha256 cellar: :any_skip_relocation, sonoma:        "eed8735a5f8c05b7f391212f857cddfe87a5cea1fcaa6b9e517e68a62755d88a"
    sha256 cellar: :any_skip_relocation, ventura:       "8c37467c27e7c4c290c4e826bc024e0c472974fc298444782a494746bc3422c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dda3a3d099b654907b03c4d4fd634a6a868ac7d3d2262caf8f226dea6524f400"
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

    generate_completions_from_executable(bin/"oh-my-posh", "completion")
    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "Oh My Posh", shell_output("#{bin}/oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
  end
end
