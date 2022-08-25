class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.8.2.tar.gz"
  sha256 "890972fbf1a7f0a336c0f20e1e9ecc756c62d3debd75d22b596af993a3d8af01"
  license "Apache-2.0"
  revision 1
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5757e9fd044750fe69b85a45006cb01a5f15303df1b9fd5a5c15e5b295bacc86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c56c62f9792c2e05ba693941e7c8e01b59c990246651ea01e8992ced236bb2c"
    sha256 cellar: :any_skip_relocation, monterey:       "07d1a0f50138bb3b27cbd7753ad0ccc6f5cbe253d114441d54616bacef0a9173"
    sha256 cellar: :any_skip_relocation, big_sur:        "04bd25cca9751adc20bb632037a34fe8f7a8fec8e5a58921dda4a8ace8437441"
    sha256 cellar: :any_skip_relocation, catalina:       "380058259f2a13e39066b5725a976cdc9ea29c2ac6f16fd14fc5fbd8c1f3848d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53f0b28a72f091b733af5547ca47e304eaa4f0b058170b3fc6996879e6c4ccae"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/dust.bash"
    fish_completion.install "completions/dust.fish"
    zsh_completion.install "completions/_dust"
  end

  test do
    assert_match(/\d+.+?\./, shell_output("#{bin}/dust -n 1"))
  end
end
