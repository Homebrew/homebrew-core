class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.17.0.tar.gz"
  sha256 "dd83ac9685968a572297b2cd8f421db4cebd54ef2752e46263ffc17afe1b7aec"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ede980328e3603a7546d31a9a6e36d059c8c20a3f304bf83268f6493a24697d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4d80276be88c41c5144ef2ab2181a7a5bffd361a88534e4081c8a4d30556a75"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6310f09d08b5f93a32378f574cfa9c312752118ce93e7fcceb07b5b43adc1534"
    sha256 cellar: :any_skip_relocation, ventura:        "c6389bf58b124985e9021017da4b13acafd78c915194c6312eb73fb299e69fac"
    sha256 cellar: :any_skip_relocation, monterey:       "3c7508123cbf67bc9918e226860efdd41665d35b43b6b2e231db651c8a65cd0a"
    sha256 cellar: :any_skip_relocation, big_sur:        "da1223b92c18436f20a69e2a7cf4136221040d9eb4945905abe7e4b93f971bf3"
    sha256 cellar: :any_skip_relocation, catalina:       "148e346e8bf4ab1d827efb9fc5d5bf5a7fb74eb899cf356adf14bcff9c089005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5de717abded5346718cab5ac3f4205031cd29f72b89fafd7ef3b8fc72248b57"
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
