class Dehydrated < Formula
  desc "LetsEncrypt/acme client implemented as a shell-script"
  homepage "https://dehydrated.io"
  url "https://github.com/dehydrated-io/dehydrated/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "34d0e316dd86108cf302fddfe1c6d7b72c2fa98bed338ddd6c0155da2ec75a94"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "50d65a084449712eea356f6b150cfd16dd91b0482e9affcc85b8c857d729cc16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "50d65a084449712eea356f6b150cfd16dd91b0482e9affcc85b8c857d729cc16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "50d65a084449712eea356f6b150cfd16dd91b0482e9affcc85b8c857d729cc16"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3150342ef796696d20b730330b6098ce35da74b972d4f14f8ad85932d398de9"
    sha256 cellar: :any_skip_relocation, ventura:       "f3150342ef796696d20b730330b6098ce35da74b972d4f14f8ad85932d398de9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50d65a084449712eea356f6b150cfd16dd91b0482e9affcc85b8c857d729cc16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50d65a084449712eea356f6b150cfd16dd91b0482e9affcc85b8c857d729cc16"
  end

  def install
    bin.install "dehydrated"
    man1.install "docs/man/dehydrated.1"
  end

  test do
    system bin/"dehydrated", "--help"
  end
end
