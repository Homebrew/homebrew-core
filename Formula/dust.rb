class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.8.5.tar.gz"
  sha256 "0eff8b1b4e53f5ec2ffc0cfb9e5500bf27a9a5a68b1ff115c98facb4d20a7b7c"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a65013abedb991a36ddd4cfdb838f740bf8018b9cbdd96c1dd2d003a4214745"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5241603619cbe3271772faabd3cca9c1173a5a9deee52f4d7b83710e0cec058e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22f6df699cc7c174ba960aed32ebc41b01f1e5d8d5fd11ff72429016f344ffe3"
    sha256 cellar: :any_skip_relocation, ventura:        "7ede3b80c9d2284fc14705273259446a560f3947a215e7e15700e53081cd794a"
    sha256 cellar: :any_skip_relocation, monterey:       "8d058ce2b61e7a6f2fcdc8cedac8e246599bf666413d5802def46a47d4e6b36f"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd31ce0e250725898b300667ecf62686f94960e5e4113c14ee0962a4d2a93c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c1aa1fb3ae017c18f72d835a35116a2c6be07c62c24b18cf68ce3bd74e388ea"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/dust.bash"
    fish_completion.install "completions/dust.fish"
    zsh_completion.install "completions/_dust"
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
