class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.15.3.tar.gz"
  sha256 "80adf2a7c3c4e90a26e59bdae2d1ca7ff41dd455a5a0b61f02e0eb79c79f1e53"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c7a19aa0d0eace22ac049e2678d8831263591635151a351731d05b37ef16236"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6ef6c1e3c9c6be3286a9794d86b7eaadf71d571e15c0fbb25c61c59576af558"
    sha256 cellar: :any_skip_relocation, monterey:       "1b08dd383501c540f4226aa05bc656173617f997e7183dedf78ea002c6b66606"
    sha256 cellar: :any_skip_relocation, big_sur:        "f23ae4076c71ac9f65b4a335cb0710f55c1120f6263a4fd876f64b24a42d4367"
    sha256 cellar: :any_skip_relocation, catalina:       "b3c42c9ab3f044921524bac096628335e9de5d775742338ab5f930529b8f0005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "561b7fc402ca3e395d510645bc5e32a238d43493bb00033d0845d6e7e61e2cdc"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
