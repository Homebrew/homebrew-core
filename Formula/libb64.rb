class Libb64 < Formula
  desc "Base64 encoding/decoding library"
  homepage "https://libb64.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libb64/libb64/libb64/libb64-1.2.src.zip"
  sha256 "343d8d61c5cbe3d3407394f16a5390c06f8ff907bd8d614c16546310b689bfd3"

  def install
    system "make"
    bin.mkpath
    bin.install "base64/base64"
    include.mkpath
    include.install "include/b64"
    lib.mkpath
    lib.install "src/libb64.a"
  end

  test do
    system "#{bin}/base64", "-e", "/dev/null", "/dev/null"
  end
end
