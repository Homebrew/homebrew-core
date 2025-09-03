class Mfup < Formula
  desc "Media Fire Up – simple CLI tool to download YouTube audio/video"
  homepage "https://github.com/eshan-singh78/mfup"
  url "https://github.com/eshan-singh78/mfup/releases/download/v0.1.6/mfup-v0.1.6-macos.tar.gz"
  sha256 "45b5a91401973405f9b70abc149ffe178d4764d89f63404987c76961262be69b"
  license "MIT"

  def install
    bin.install "mfup"
  end

  test do
    output = shell_output("#{bin}/mfup --help", 2)
    assert_match "mfup - Media Fire Up", output
  end
end
