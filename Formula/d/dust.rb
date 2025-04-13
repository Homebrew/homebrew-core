class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "e879e6bf662e07cff2962b68529dd78c3bafb67541aaa76e8c9d25ecb505b850"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae87355d4a34dcd3faf75ad83c8948cafc58d2d62bd4d381e3b904d22658b8e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f95942e56163d80b2dc8c7fc656bbf75484ace461415e1b33f1973f6e0710b78"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4f211b8d9243525047070230690681b7d7aaf1546978768f2c59241288b1dd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "4e592912e74415e6e9826530cfdd82aa6b112f18c261e1144b7de3eb4a024bad"
    sha256 cellar: :any_skip_relocation, ventura:       "6822e29006988602032e639ef5d846e2eb1826725b04b2f14a4df60a451aa278"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "38e10954139f77edbb32bac6dfc8168fde6793e919838862b899f79940f470bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b2292e06d094c5c363395d48527e95d9c978d9aff6711c1847727b37683c3a1f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/dust.bash" => "dust"
    fish_completion.install "completions/dust.fish"
    zsh_completion.install "completions/_dust"

    man1.install "man-page/dust.1"
  end

  test do
    # failed with Linux CI run, but works with local run
    # https://github.com/Homebrew/homebrew-core/pull/121789#issuecomment-1407749790
    if OS.linux?
      system bin/"dust", "-n", "1"
    else
      assert_match(/\d+.+?\./, shell_output("#{bin}/dust -n 1"))
    end
  end
end
