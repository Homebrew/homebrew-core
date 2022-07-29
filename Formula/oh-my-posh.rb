class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.23.1.tar.gz"
  sha256 "8698697be2a12f3a393f48c77ddb4ff1290ffb9e3e32c7a2517a099040f8cf63"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6fb45c48e0d8584014c51a90692453cf7a331107d7ac82abf69ad79a6788fdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d90af0c8166bf091c904a9454c33bc018ed8f072e0583ff96a3aba4f337387f9"
    sha256 cellar: :any_skip_relocation, monterey:       "41ebaa57583731dc3440eb9f1c18c8d52ed5f4f3ccefefa0bbfd4d8722f347c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "1ac079cef3320c1aae0650ffa6f1c2dc0a03084556b092cac17d784dbaedbd7e"
    sha256 cellar: :any_skip_relocation, catalina:       "f9198fbb82cccad7a04757aa5dc6897a71854c9b922d7d0a83aeb23789ec74e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d9f97dd0bb7dbdba4901f66de7346b3c5c44a134d92d058d76a825a6e42b979"
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
