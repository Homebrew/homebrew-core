class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.38.1.tar.gz"
  sha256 "0d34ab833bff71e650c55cadaaa3d2aa5d6531c55fc55111bae6d966efce164e"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a31d100f3a7405121272be673228972249e7facadad2132350276e8d3a251779"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1f66d301da9cc4c00188cef85106c3350dd78f823a0e269f7344f99a195dcf7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b23a89d86918e7d98c4ca2eff42f411e89f37fca668b1b21f9042db3ebd59c6"
    sha256 cellar: :any_skip_relocation, ventura:        "b4d1437362d02ed04044de162ebd378719aae8556976e971639c686c00f29e61"
    sha256 cellar: :any_skip_relocation, monterey:       "2ffec0d6966a0b61b785fbff5d37992f0fd1de3ee3cde40bcf14c7e36c164f01"
    sha256 cellar: :any_skip_relocation, big_sur:        "9dc1656ad6a8845b743ce5eb96209ade3753d0aa264fa86039664a730d1be782"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67d70f691a8ebdb570b51ee5020f07b6889da0871f661f3f73a7af175920a1a0"
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
