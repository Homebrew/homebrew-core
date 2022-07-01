class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.10.0.tar.gz"
  sha256 "61dca27702f07288f43fe0975a5a3c37392ff02708b9b4a8d7032370e85fe78f"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1898840e367c5dc2c929d06d86f90710a017f1e50cd2e16ef90bb9c9e1582a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5efe27c8e6470f48eeb3fca8364ba8645a9315f86a11ef0d4c386783a321bfe4"
    sha256 cellar: :any_skip_relocation, monterey:       "425016f97f9ae20659b8c7959f8203668fec89a2824b5185fbe349aa54f6339d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a61c1b2cb24947b60228b6a18c3753a5a43ebfa591f0f0b08e2d05344d70b296"
    sha256 cellar: :any_skip_relocation, catalina:       "f0595eb34add6c4bccfaa26a1d20f7dde7e1fed86806f6a4eabc07a377b06365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24c48ba527024d89478173bb479dc0cb143707be8f7e51b1b42695ab91aca1f4"
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
