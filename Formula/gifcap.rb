class Gifcap < Formula
  desc "Capture video from an Android device and make a gif"
  homepage "https://github.com/outlook/gifcap"
  url "https://github.com/outlook/gifcap/archive/1.0.4.tar.gz"
  sha256 "32747a6cf77f7ea99380752ba35ecd929bb185167e5908cf910d2a92f05029ad"
  license "MIT"
  head "https://github.com/outlook/gifcap.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9500bb5f91761d490a3c522a0fc93b37108e125a74d1ae158947dc79c97b279a"
  end

  depends_on "ffmpeg"

  def install
    bin.install "gifcap"
  end

  test do
    assert_match(/^usage: gifcap/, shell_output("#{bin}/gifcap --help").strip)
  end
end
