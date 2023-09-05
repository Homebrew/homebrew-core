class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/v0.8.6.tar.gz"
  sha256 "feede818e814011207c5bfeaf06dd9fc95825c59ab70942aa9b9314791c5d6b6"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb7301a1ac99725706de148e461bcfd5942db9be82ba2d469ce8985637e34639"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02131ae69af34a8fecc6c0f89e865584366c870e8d5f096e516c56e35fdf0c2b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fe0d33bf945233dc8db9706f1c0f5dd9d42189a9760b7d2115feb9725f7b65f"
    sha256 cellar: :any_skip_relocation, ventura:        "ecb5d7462fee6d1d98c0cddb6eef6a9a5c2d614cc115c2471d14c25bab228589"
    sha256 cellar: :any_skip_relocation, monterey:       "d76a2b6bfb31e0fc5ed7f2b36387c4d7ecc2e7cccae794a43b707e10c89f8216"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a14f9ba13c4b801fc4884cbb7738a46c5e17d90ff516926b1b1ecfde90610d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe5bcd6b6947aedae3d09d9e9e6f3ac505cfb2aa03a4abd37a358c6301d46174"
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
