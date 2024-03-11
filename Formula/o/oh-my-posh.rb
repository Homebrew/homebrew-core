class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.15.0.tar.gz"
  sha256 "72b296fae2e42a368acabf06a6e5b040155e05b2a0f195e5701599dc9a5c9389"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c0b610cdd6226e6d604666e7631bc6d8ef8c0fb9870e699cc13abaf5889c1d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d03aa90b7c58f03aff11bfb962b6cde9ceda1f42e26b19097958735340dc1504"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5bf5d8facf74645f2864640339a0021d2326348a6bd5a378fbb832de611874bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a503fdc76221dfc1055e3380c04091aaa33829a7ba941fab07044b946556dbf"
    sha256 cellar: :any_skip_relocation, ventura:        "a8e86fd3c5b03eda61d29091db527b9d63a447f7c7c1eed1f32abb46530dc1ee"
    sha256 cellar: :any_skip_relocation, monterey:       "66d94cbf3cdba19540b5851e1bef1c2d890a8a3a530fc98f13041ad182c884d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a089d6297740df867b6140d75ea1914c8f3fc399f6a384a8148c76de95cdc39"
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
