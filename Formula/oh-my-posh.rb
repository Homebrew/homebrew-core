class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.8.0.tar.gz"
  sha256 "ccdb98408ec1ae00b4d92091a0f0defcc85e1ea52d59cd9fd4c4036235e27f9d"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "de9b0400975dceb8d9b283e1f7cd021c3dca40f31d72f84f5e3b17c10ef02c4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3d749d2ef226ada181c1183c21806d7d5032d297c8987e1352138fcb3409d06"
    sha256 cellar: :any_skip_relocation, monterey:       "e8945c6a89553f2c55a3d137f048e1d604543143922810dcf5e46b584254cb2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab29de814e2fafac4afea3b4b74b420700dd88430ec16f55470f6731bb6c98bb"
    sha256 cellar: :any_skip_relocation, catalina:       "9dfb302fd1159260fde865b3ba9583252dd2f74d5fcb299f3de25999e3b54b00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2940624f803e80a44702f4226f93353078dc1c1655466d7c6d75cdcf7d0c91ed"
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
