class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.7.1.tar.gz"
  sha256 "5706524e96ecb95daa699e7a03b3c3bff9b7ab77150caf2357e167534b8c9884"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75621c562f898683c8bb30e68b02aeb410bbdd5777d8441778d0dd7a16b6a5ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4eae86d37389132fb09ee3c3386d2ba6e604d5fff7528209c4d955d24e6a7de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6570d1f0259520781958c08a1c23063534a42f7658751d3fd97f148cb573fa5b"
    sha256 cellar: :any_skip_relocation, ventura:        "e049ff9a279180d08ce95abbdbde805237c57e05aff323c758b6e8ea8458f619"
    sha256 cellar: :any_skip_relocation, monterey:       "26ddb9d812178eb01fd69df70b4ab83ae0b87c190842bb4448b45f945ba0bb48"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad6afdf31b5e785ae106625465fdcb6d81461be443eac0b0f00bce52e2efeef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d39551dedb7aa7e5d29e701dec889a5148f2877256ea50d73f06c0d5b70677f2"
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
