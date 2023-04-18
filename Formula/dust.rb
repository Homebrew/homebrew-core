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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e389c52cd8ef6748051b8babaa0e9f3005a162075636fbb776297e7a0c130cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eeeed6c181f0c5a7ba6959a0ad5b84c7d973fdbf198264f33cb16eb6d842b255"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9525f3c9cbe76e3e580861f0330649525300f52a11277e2f81b1dfcca3997468"
    sha256 cellar: :any_skip_relocation, ventura:        "e36ab16bae02c6a098b26021f3a4d50ec1ead5635eb5cb18f67dd3eb8cf86e6e"
    sha256 cellar: :any_skip_relocation, monterey:       "ce116021c8377348bf357d0ee53969cc7935e55e58ccea9ff717ecde5d468bdd"
    sha256 cellar: :any_skip_relocation, big_sur:        "44590ab485bd6f8329d2d3c3895cc17bf0d10239410708577eb26ce29710bb84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4ead35bacacfdb7d99ef7774afb839e009e5c5c26fbe18aff184bb18c76929d"
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
