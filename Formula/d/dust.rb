class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "2f6768534bd01727234e67f1dd3754c9547aa18c715f6ee52094e881ebac50e3"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ea7278341b70f5971cbcbb35c5dbb817eb69865e1acd6c59335a09ecba1ba26"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "14b3826c4f2109aa86d30b1952748620968130ce6af0ccd2a94d0ffacf49def0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "251e220c57fc640bdaa2962c2428a4f1738b732a0f2c0418bb6a1d7d04b8f63e"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b883a64823bb7861927ae575bbd3be0065f6ceccfe2b38f1f2924b51752f469"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e05fcc7b985571840fae0e6a9efc9f604ab1f9443525f2e0cb31c261485e07b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63c496858bede87bdd74dd11ff493cdaa855bed9321f0ba16899b6c12c6569a0"
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
