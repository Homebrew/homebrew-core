class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.94.1.tar.gz"
  sha256 "9c6a8c8f4d688ab2a9fb8527cceeaef2238dc2a6f0abfa95e937873f6dc72114"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0ae31318181311b20375b6299743f4cbad7c9cd30f1ac7887bc569bf3f9197d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f11264489500b6388d079d98a54c5b27ab1b0af8a4199d56c10487cd8c4cd6df"
    sha256 cellar: :any_skip_relocation, monterey:       "70fc2cca68e910eb14911bf45f9fba3f48c0a63878e98ba72037409e49b6af33"
    sha256 cellar: :any_skip_relocation, big_sur:        "dce499fe9cba2fb690cf7b5d34a7e35ee5ad4c201d8014366e3cbbebae4024d5"
    sha256 cellar: :any_skip_relocation, catalina:       "d638c485d7df88521e901b5ac80e4b78b744784291bca7416742f442f7ef8398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "80ff95fa93b7e6ece3aa9f9df25ab0549810f55937521465266be09c5b4d9d63"
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
