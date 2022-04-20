class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.66.0.tar.gz"
  sha256 "d89c355fcfd16bbd94660710fdd18a4f9d26c0820e66879f9ce60b7ddcedebb3"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e558949f385f7b6e143770824e0108c3a6e14f294b0502267786487183f492eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8375d1e75d3209218ef31c6fd341007c662673601ae3a7f0a3c1a6619542842"
    sha256 cellar: :any_skip_relocation, monterey:       "16b7f6c04a77bfe8cd6474249a312a7505e8dcfd0bf40839c40380e022521ff1"
    sha256 cellar: :any_skip_relocation, big_sur:        "a023083aab31a5ee49e2af8e115296b06b6ccfc2862512ac89fdb6cc37cdcd5b"
    sha256 cellar: :any_skip_relocation, catalina:       "6e49c7e6288e4ee4b59b8d69c147cb91db0cfb34c8c4c46a4b80c592f4a0311f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "730fef9895bb0db157fc21998b38c30ff245e72ee539d21b8ffb0f3f6e455dbf"
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
    pkgshare.install "themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
