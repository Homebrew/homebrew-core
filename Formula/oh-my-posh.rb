class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.18.2.tar.gz"
  sha256 "88d7cf56ee75d350ee6423715b2bc50f6643ef8cbd51e595a2e9ecd924dd7a5a"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a67d7ee87d45073b6fdfdb805785fecc40e32aaf6b0348ef344c42701a6f117f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d22674996b2dc380167429388f0f9ef15894133e327275561975a77d8fc91e8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5717e936ec898b3d44ebfb0afac2cd6ce4d6f3ead5dde242a78d07df4fca8000"
    sha256 cellar: :any_skip_relocation, monterey:       "1339750d862a7ed9cd2fc1290b95ce3accde0aa57e689ace426f5f2a62be944f"
    sha256 cellar: :any_skip_relocation, big_sur:        "72e585f8e629908d324ba291e89a30986804635d3f36ad3c57b5aec9a219ff75"
    sha256 cellar: :any_skip_relocation, catalina:       "b29e072ebb2f8182d4214cca4fd671a2a32fa947a178bc532eeb0cc009577171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "707640103bdbb38ad053c6f258e09d0c40b612c17e10e93fff61ea91f502a729"
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
