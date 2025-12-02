class Dust < Formula
  desc "More intuitive version of du in rust"
  homepage "https://github.com/bootandy/dust"
  url "https://github.com/bootandy/dust/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "424b26adfbafeac31da269ecb3f189eca09803e60fad90b3ff692cf52e0aeeee"
  license "Apache-2.0"
  head "https://github.com/bootandy/dust.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bb2ac3f18d5a554c04f322f02b01a1f34714c9b88af9bd9c87d0bd46fb318c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13d106cde2640253e23c18c035490d070f493ec1857e5d3accbe990f0884bcff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e60f1cdcd20231549cc68c1aef4a45cc952cef13f32fcd78799d6d9f9becbbf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58e0a6dc31b4535da9aa1f2051f71d6b60c28df37ef82385a95b7a72089fe60c"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa1cd3f1e018cd69676f469d4a2bda21c63bbba4f9af975c07e6df2d85e28279"
    sha256 cellar: :any_skip_relocation, ventura:       "1c89bb6736dcbc915b7b9b03d4bf8e421b6e0d93c0e725b43876d321a0074ceb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95b52f20a5ebb1c86f159965b2df71fff01c376964f8d88e1e68cc99bcc1ef83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1929bf6d09aad67060840c5a1cd466ef5fddb0c9d4a0674d11b1cd516ff027b"
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
