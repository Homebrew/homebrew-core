class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v10.3.0.tar.gz"
  sha256 "8d41bd3046c656480b6a01f892b3d0689657189d95476199e3e43aaea9cb2b77"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b065bdb6bdc3096ee4a0765e9055eea3e44662afba32254845cf87353b64d19e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55496f101b576c269450a0c44177b2692999105dead60c83d0b947607e135f2a"
    sha256 cellar: :any_skip_relocation, monterey:       "0c404d107a9110659942e15f0318eb60553990acd7ba847ad10049fd25edaa1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa574661d5be390122d475916b8be57e1ee8e4bbbe8956bc3d0d2b951d06746a"
    sha256 cellar: :any_skip_relocation, catalina:       "154523fc7ab9f95330448cc8163cca53f833f7927c33e5af5190ce00b4d24d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09d15ec1e1aff0e29c638770e9b895a650becc34ce69704b6b4871d8265b152f"
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
