class Fnt < Formula
  desc "Apt for fonts, the missing font manager for macOS/linux"
  homepage "https://github.com/alexmyczko/fnt"
  url "https://github.com/alexmyczko/fnt/archive/refs/tags/1.8.tar.gz"
  sha256 "9d0888ead98aae4d47ecb23d8208d4d48faea1c1628d49d00cea7c795afb8b65"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c203667f19a6d4c8380bea8d798f2796562bf5cf8a7e3e0110ea44c0714984b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c203667f19a6d4c8380bea8d798f2796562bf5cf8a7e3e0110ea44c0714984b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c203667f19a6d4c8380bea8d798f2796562bf5cf8a7e3e0110ea44c0714984b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee0fc8f0dd7c4b3d122d870fb2e3c8591d33f69c8510dd85bf7dda90e2e0205f"
    sha256 cellar: :any_skip_relocation, ventura:       "ee0fc8f0dd7c4b3d122d870fb2e3c8591d33f69c8510dd85bf7dda90e2e0205f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c203667f19a6d4c8380bea8d798f2796562bf5cf8a7e3e0110ea44c0714984b"
  end

  depends_on "chafa"
  depends_on "lcdf-typetools"
  depends_on "xz"

  def install
    bin.install "fnt"
    man1.install "fnt.1"
    zsh_completion.install "completions/_fnt"
  end

  test do
    assert_match "Available Fonts", shell_output("#{bin}/fnt info")
  end
end
