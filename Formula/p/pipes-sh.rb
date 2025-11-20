class PipesSh < Formula
  desc "Animated pipes terminal screensaver"
  homepage "https://github.com/pipeseroni/pipes.sh"
  url "https://github.com/pipeseroni/pipes.sh/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "532976dd8dc2d98330c45a8bcb6d7dc19e0b0e30bba8872dcce352361655a426"
  license "MIT"
  head "https://github.com/pipeseroni/pipes.sh.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "339995e9ef29b4952bf61b4fe406d71c4c6ad5fc96e3e8f291d98150c6789cb8"
  end

  depends_on "bash"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/pipes.sh -v").strip.split[-1]
  end
end
