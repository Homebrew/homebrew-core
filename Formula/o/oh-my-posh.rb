class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v21.4.0.tar.gz"
  sha256 "76476941b958c88a4f14bdce57d452c324c3dd2ead7422f90e93485273b7383f"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5fa863a47eca5e4d7b065e9d8725ef5223060b4c8bfe9513cb4a4108ae64c642"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e6c6157423eb9aab5b2b6caea8f36259671e2af19519399f1f72f6791292d3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b7d366fdaaa1c234695dccdbb97e7eb0465a94cb85ae0ba5ee52fb38926727c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d179aab1ec0451609eb67deab66ce9d806a4a93329b50c5c0a4abe46202868e"
    sha256 cellar: :any_skip_relocation, ventura:        "98749f43bcb65a0f253452166cdc8d5e87f15cdeb488b6e4f00acf0149b8fb70"
    sha256 cellar: :any_skip_relocation, monterey:       "9e3849065d2f1313d5d56233e10b55916940624daca0abbb73ef80b73cbde9db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f6d9b43ec234076cb5925baac81d454026d2cf80cf2ab41f9914317f02998f6"
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
