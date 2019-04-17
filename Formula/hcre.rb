class Hcre < Formula
  desc "A brew implementation of Hashcat's rule engine"
  homepage "https://github.com/Viltaria/homebrew-hcre"
  url "https://github.com/Viltaria/homebrew-hcre/raw/master/archive/hcre-1.0.0.tar.gz"
  sha256 "3bf42f2b407f3cb6540fba2b2168e0b585313d63e4ddd4d4665fa042003e0011"
  version "1.0.0"

  depends_on "gcc"

  bottle :unneeded

  def install
    bin.install "hcre"
  end
end