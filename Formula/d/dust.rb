class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "9dd1ec7576d43574e6f48342cb96a5087338b4c308460a848f5895f72ddc3bc9"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a4629a8f9efe50acde6bb93815f41285c530edfe26d98f4083d3b058c3fc71da"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1012137818b9c1d28d30e28bdce6f82ff34090328890adca39b927fe7ba850b7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "52dc5e4b48d504edb90048fbccb961054e96c06388c4b676f88b667ee34545fb"
    sha256 cellar: :any,                 arm64_linux:       "12dfd66b128bed2bf7756944a011e8b30b0abfe59eed1b4970c5fa9613d7f938"
    sha256 cellar: :any,                 x86_64_linux:      "5886d5c418efd219cf5bd77bda3c167c452261ba612bc91da9c13aa13c6ddc3d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", "--locked", "--target", "host-tuple"
  end

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
