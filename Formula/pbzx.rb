class Pbzx < Formula
  desc "The pbzx stream parser"
  homepage "https://github.com/NiklasRosenstein/pbzx/"
  url "https://github.com/NiklasRosenstein/pbzx/archive/v1.0.2.tar.gz"
  sha256 "33db3cf9dc70ae704e1bbfba52c984f4c6dbfd0cc4449fa16408910e22b4fd90"
  head "https://github.com/NiklasRosenstein/pbzx.git"

  depends_on "xz"

  uses_from_macos "xar"

  def install
    system ENV.cc, "-llzma", "-lxar", "pbzx.c", "-o", "pbzx"
    bin.install "pbzx"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pbzx -v")
  end
end
