class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "34b72116ab6db9bdb97bc1e49dadf392a1619838204b44b0a4695539d54ffbe8"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c1bf858e5e6c2bdeb117f49db5ddd722a4cb4c07599472d270a697682e277ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "264334f013abc44bcaecd6c8229070091f9cbc0ee584ff4b9dcf894dd41a40be"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc27b077b2c687b4c94de4958f39dd04b75ff69b255f097ef19391730deb7c80"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e43b7160bb0ec65040abab0455110acdc0626576e149bf4092f0ff9075c3e4c"
    sha256 cellar: :any_skip_relocation, ventura:        "1f236a0c2c0ad9fa066d074fcf9809a5a5cba5676f4eca813f0b57270a9a50ea"
    sha256 cellar: :any_skip_relocation, monterey:       "e087273d5b15d676b98ab07be99618ee5d9f43d5ebd0e65f74040be7d4a5009e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9eaeb7e87c5deb6e904ced7d6ac62b2a9e87a24047be3d2b9e68300b940bcfa"
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
