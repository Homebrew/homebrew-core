class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v17.0.0.tar.gz"
  sha256 "58b03ce38ef8f7e01b093590f7fb926c9ad1c0998a51ed21b605bb8ad43b855a"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3536b5876aac9d19e276977526dea0c5ad894c7908fd95f6f09eaff43802109f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0abb6f065b2e34adb80a15dc11fbef29b5d5894b66734acc38ba6c29f2ff45b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "982834c364cec11f630b56426420e6a6fbba736e70d9767f814dcb193c4ee9e3"
    sha256 cellar: :any_skip_relocation, ventura:        "a486b26aa2523503207e8517c7fbe5c3c17da13f787279798357bd61c7947e12"
    sha256 cellar: :any_skip_relocation, monterey:       "407447b270e6723cc93137fe51090780dcf1a43ce0e349448e9cc6318dbece11"
    sha256 cellar: :any_skip_relocation, big_sur:        "8338ff7c1e6755c359a4124ebe74cc453607a0a40692afee765075bce0342534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7a65b49d0d9cc3690797dfc354529069d6ef16d090a7e6ef1049c7dc4527b95"
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
