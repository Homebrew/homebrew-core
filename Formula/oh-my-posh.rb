class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v11.0.1.tar.gz"
  sha256 "cc70b0437f1798d957becd4732be9eaedd1533210af7eed5ce554da1e400ba63"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5ee95ef6cf512fa5b5a8dd0146b181e79c9a474088fdca16410687e8f35830f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2c35fbd919499eab4b819f633b8ea4df53c10c9bd807a6ccb7b37258595da6d"
    sha256 cellar: :any_skip_relocation, monterey:       "441d28acf53652ecfd8e92d69f89d1d428c2ce53aaa555f291fd170280f549e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "931c224c83a28d8f337be844bd5119545089ba9551ae48e7d337b895e3bee4c1"
    sha256 cellar: :any_skip_relocation, catalina:       "5e1463dafa8fb4de09b936f910430b9291e1944015acb4de2a31e61cebcc8568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8658eef889ebe6cefade861783c86e62037939849fefd3923fd45be580d3a1c0"
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
