class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.5.0.tar.gz"
  sha256 "a0327d7bec7f4e0fb4a65902ea174781e27da75e1318b40c4417082ebb7dce13"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29e24313bca15a1b104e5f32326617a188828a10790cf2a3fe6d9f740b73ca03"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48be4ad8a5253cd50228495c79c6081235cbed8379f54bea7406a27f1ab0304b"
    sha256 cellar: :any_skip_relocation, monterey:       "6b06e0e349ec744df2336b4e8be15f6846f0875f543b3efa4b9da010073e3d23"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cba8cc31c2fae6d517ac2ccbb742758ac3cb7c725f65311b2627a2540be363b"
    sha256 cellar: :any_skip_relocation, catalina:       "70f43cb6065959c9bd74ae8195982e9905627169fc0ea75dd64a13adc7a0f07b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a15d612df71cdb7395e18fa947fd7cc0253a0a6f5264c1e2c7c6adb946fc53dd"
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
