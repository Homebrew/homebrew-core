class Dehydrated < Formula
  desc "LetsEncrypt/acme client implemented as a shell-script"
  homepage "https://dehydrated.io"
  url "https://github.com/dehydrated-io/dehydrated/archive/v0.7.0.tar.gz"
  sha256 "1c5f12c2e57e64b1762803f82f0f7e767a72e65a6ce68e4d1ec197e61b9dc4f9"
  license "MIT"

  bottle :unneeded

  def install
    bin.install "dehydrated"
    man1.install "docs/man/dehydrated.1"
  end

  test do
    system bin/"dehydrated", "--help"
  end
end
