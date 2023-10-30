class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.18.1.tar.gz"
  sha256 "e566e0678470efa8097c1c7b71a01deaed7b072e38ac811289a004bbfc706f30"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "08f7eaca6e2e21db598ba9acdb42806f5a389afc4783cead17f7b129429c2f35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82f7079d055b1978f6fbe854f15db52f6b1942eb32264d24c94790c71720e057"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49481137cc422c8bc55ec98c889c0422a884cc50ba6b65808c08773944bc4124"
    sha256 cellar: :any_skip_relocation, sonoma:         "5553307f451ef4d834a5ddf4b1da8a44ad6c630d4318c6f76aa605ac217a8e0f"
    sha256 cellar: :any_skip_relocation, ventura:        "e7e1cb0dd0175f51eded32485441c62e62ebdc23aa9caef349f9b910f86b42fb"
    sha256 cellar: :any_skip_relocation, monterey:       "dc87eb874e929e33c3ed375c3b833c5908c92e7f0d3951d1c38651cf08f79506"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0df3008c4fca0c33ac07ecf96065526ca1fbb200081dd0ec1c7ed66315954e4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
