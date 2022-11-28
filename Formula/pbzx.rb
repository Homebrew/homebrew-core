class Pbzx < Formula
  desc "Parser for pbzx stream"
  homepage "https://github.com/NiklasRosenstein/pbzx/"
  url "https://github.com/NiklasRosenstein/pbzx/archive/v1.0.2.tar.gz"
  sha256 "33db3cf9dc70ae704e1bbfba52c984f4c6dbfd0cc4449fa16408910e22b4fd90"
  license "GPL-3.0-or-later"
  head "https://github.com/NiklasRosenstein/pbzx.git", branch: "master"

  depends_on "xz"
  # pbzx is a format employed OSX disk images
  depends_on :macos

  def install
    system ENV.cc, "-llzma", "-lxar", "pbzx.c", "-o", "pbzx"
    bin.install "pbzx"
  end

  test do
    assert_match "0 blocks", shell_output("#{bin}/pbzx -n Payload | cpio -i 2>&1")

    assert_match version.to_s, shell_output("#{bin}/pbzx -v")
  end
end
