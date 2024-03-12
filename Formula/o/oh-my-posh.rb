class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.16.0.tar.gz"
  sha256 "3e7b1743cc16b53b77bd0ee99b6797f84d1079b3534faf341ebf017180b92759"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "24589559b07d1e9ecd2e3bd5495ace372f6ef3805a5e8bd3293b7f8968496055"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "17d97122cbc9d5f382097806e234081533d9bb973a0d391b0d04120c52a7cd84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2abda5281c573ce815df3bb88c66733845950c5088ef7879a3730a56fb5d7c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca96f2ba071d7904ff330a039ecdb15d81356c90947a665da9ad989f42e7a6ef"
    sha256 cellar: :any_skip_relocation, ventura:        "3a0ee923743069afb4755de5fdabe6bf2c363c7d38c979299ed00c9d33223212"
    sha256 cellar: :any_skip_relocation, monterey:       "682dc5ceb499af794139ccb9c789723951c5c669e1825b9adb6fec2c3d079409"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e2c5de0435fb49a2c5e079a468edfd9be59da3fe2078f60728393c06221a50f"
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
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
