class GqCli < Formula
  desc "Command-line interface for GQ"
  homepage "https://goquant.io"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, monterey: "b21e0a5f4238130218bfae10c6604a05263e9ef52f462af246d54a93f54821d1"
  end

  on_macos do
    on_arm do
      url "https://brickelldatabros1aboah.blob.core.windows.net/public/gq-arm-0.0.1.big_sur.bottle.tar.gz"
      sha256 "d8d14a758174c9f67bb7adaf4d4a8897f3b3fa3b7f4338eb86f2c2c222e9a785"
    end

    on_intel do
      url "https://brickelldatabros1aboah.blob.core.windows.net/public/gq-x86-0.0.1.high_sierra.bottle.tar.gz"
      sha256 "99a64a8b7164c66a03aa8f34e68a7acb4cf2254642345839c742afd989a5f2f1"
    end
  end

  def install
    bin.install "gq"
  end

  def post_install
    system "sudo", "chmod", "+x", "#{bin}/gq"
  end

  test do
    system "#{bin}/gq", "--version"
  end
end
