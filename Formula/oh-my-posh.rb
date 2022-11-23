class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.18.1.tar.gz"
  sha256 "377bbd59f0c3a8599bf2975e9ed41e3c83ab1401e324f0699d2c823226016aee"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cf0375b6f2d8914b569c25edf00660df0feb10445466f9561a872117b80e789"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35d745d7cf8fd83562d1b958cce86900985a5ee001815772353adf4694e8b29e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2979ff4ade87e35fe448cbc0b092d4f90ebfd11bd181157d73dfa3d51b570e94"
    sha256 cellar: :any_skip_relocation, monterey:       "6de8d34450f5460cdc7248caf630214ce62ea2f9b76040967db2fa40a0dd7dee"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff5e25a32943b3aec9f58d320447155ef7d1c3757f01eda6476d76c1a4836b53"
    sha256 cellar: :any_skip_relocation, catalina:       "eef42368e3f52d3e4ff8e7e2646bf9bd1c3847540ac65be8b6e49251a460bca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc8296551636aa531da4259d1b31646fe4ef2166ad0c54dc99c0da63fff6bba9"
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
