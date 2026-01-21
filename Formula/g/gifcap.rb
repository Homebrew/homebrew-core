class Gifcap < Formula
  desc "Capture video from an Android device and make a gif"
  homepage "https://github.com/outlook/gifcap"
  url "https://github.com/outlook/gifcap/archive/refs/tags/1.0.4.tar.gz"
  sha256 "32747a6cf77f7ea99380752ba35ecd929bb185167e5908cf910d2a92f05029ad"
  license "MIT"
  head "https://github.com/outlook/gifcap.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "444ff7c3428195689d64e4d9700488e04ae1837e87cc93c71a42a0d1e8a8a9ea"
  end

  depends_on "ffmpeg"

  def install
    bin.install "gifcap"
  end

  test do
    assert_match(/^usage: gifcap/, shell_output("#{bin}/gifcap --help").strip)
  end
end
