class Presenterm < Formula
  desc "Terminal slideshow tool"
  homepage "https://github.com/mfontanini/presenterm"
  url "https://github.com/mfontanini/presenterm/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "9ae89ca7f4bae9918dc9764062272b9ed9b040586c5fab4ce258b9c76ffa7478"
  license "BSD-2-Clause"
  head "https://github.com/mfontanini/presenterm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6b13c511db24c66943a692646eb5e41a39ac978b754b5fa267156edf19b375be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69a22c5e7ca8851afb064bc9342b1193476808e92d2c723bf064609a0c92fe3d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79f4cf0e0404d12b499a219d0d6d812d93d7dfbcabb4aa0992c3f02e5c59d08e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0e498dc1151808afedd4910733868ab2718741f3cfe878766046f69e2c160375"
    sha256 cellar: :any_skip_relocation, ventura:        "a26a43f2329dcb792dbb78a4a874f9023616815ca83014dc969a4bfb70a82cba"
    sha256 cellar: :any_skip_relocation, monterey:       "cb0f106b4ce1a56d74ccdfbcf9603c523a584888bb1650311e0211b4a45a2ed7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a98e545cef3b528af30dfd90b61a38a6b5dc50311a1c0903f85df3f72316f8e"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # presenterm is a TUI application
    assert_match version.to_s, shell_output("#{bin}/presenterm --version")
  end
end
