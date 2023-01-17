class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v13.3.0.tar.gz"
  sha256 "1ede299ea791e2f7bd0214ad4ba9321cc66d0f7036ebb039f12bdb37fc69d02d"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94928cf414f6919d7332f692124163213711692c6ebfabb4ee13ac127f54a097"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77b79a6f96eedeaadec461dd3de48aa1882c427b3824c25730fb29ca0c82cff0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf5040ee91a660ffffd7449d4c311915d00ef2f8b3bf8eeae5d189de107e017b"
    sha256 cellar: :any_skip_relocation, ventura:        "3982c46a349b99a2548988bd6c268c795e6fe9cf010a21b604c85e349586cbed"
    sha256 cellar: :any_skip_relocation, monterey:       "cb08642d039f446849f5d16ec72635ff58b1faadb39057a51640d273297c4d55"
    sha256 cellar: :any_skip_relocation, big_sur:        "030e5adaaa861470c37df6b3688d21c8c3392392ceed171636fbf7e09b6e4867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a784043157328f8151b8a34d825f99cab6602ff6424140355213faaad10ef74e"
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
