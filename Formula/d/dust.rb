class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/refs/tags/v1.1.1.tar.gz"
  sha256 "98cae3e4b32514e51fcc1ed07fdbe6929d4b80942925348cc6e57b308d9c4cb0"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "00f415d936d1e3311e0bce04b8173d981acd4e81df7b71df95c9c8dc4f0feaa0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34754de221680f27966d1f9144384f16309344bbcbbdfd4a5abaaecfeda21ce7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e7f5ad55de4ecaf061118e300993278ec4d86effc7907f1c3371914c9ffc80d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b095326b2ae7fe89d4cef623c0ee606059a2d43fbc98d89a956cc41bc86ac0f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f70304285ff4bfd98e4a4eea86b63aa31b7cd131f17e40ae6c60e78b577d64b"
    sha256 cellar: :any_skip_relocation, ventura:        "e34c0a5399f84cfe5129300f51bbc2f0da6bb7610d87c1272fae14900bc50c66"
    sha256 cellar: :any_skip_relocation, monterey:       "1171134bc2953b1b9b4dddeec80dc5d373d53565aa82443fcfcc1ecbfe27c71a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61c98c2c3b31a1be9febaf4bdc3eadf64ac8876c1b26403bf384a092954b116c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "completions/dust.bash"
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
