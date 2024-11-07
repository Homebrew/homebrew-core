class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v24.0.11.tar.gz"
  sha256 "d66c0cbf157bc4af838418535fdf9d7bd94be14b5c1f06d53a4b8366cdb87712"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "140d653e94388d6afef6c411d5bf968bf0cb5bb3af8ed6e8991c5b332722be2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a6c93cbe3bb6d689f02a77d59af92f2801dc9ab7671b34e3eeb05fd3375ab21b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9094758f39e094ffa51512fe3ac3e62ff7652478587dca3f4cc3630ea3779250"
    sha256 cellar: :any_skip_relocation, sonoma:        "0731eef6b87c504df4e16480a1e2779b0c6d7e8acc5134944894ff650edf121e"
    sha256 cellar: :any_skip_relocation, ventura:       "5b5b8d877b1c6fc816ddb02ba56f62f98af70c075d5cebd1fecf4d065abaa110"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d6936833d1d4590313aad1c145a290e38b3fd21ea2d519de9bcf1dc9bc989ed"
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
