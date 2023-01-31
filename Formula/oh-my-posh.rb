class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.0.1.tar.gz"
  sha256 "3fa4c68c97149f1bc5d88ecf3f03218d7de8fd4126dc3489d0a45c01c3dcf367"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1efc5d43eeb64d8de3de6948d037efb1379f69c10adb3e4cb52d5372553d7e1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f717dc8e59cbb4ad5f50f2c6916c5af6f5184afe5b59904717405bcc6d3e42d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "df13c2e3862ebef58f82c6670dd4e72709a7620b3a57cf916c71a4f7f486eae7"
    sha256 cellar: :any_skip_relocation, ventura:        "541b4ab3f9dab3abcb95eb24a7ccf768c201cc25a3a040371a58b0397fc05620"
    sha256 cellar: :any_skip_relocation, monterey:       "5eb9ca981dc69e89471645d31fd34dc24f31e532f9cefe3dcfffe9c7cfee1eae"
    sha256 cellar: :any_skip_relocation, big_sur:        "4dd18307a2b321afde0849103a33c579afe112a1af2cba315e383de6d3df3421"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "095678d976f842b131ef38022034860a58b0b1ede62be7877309ad089b344926"
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
