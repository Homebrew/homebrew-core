class PipesSh < Formula
  desc "Animated pipes terminal screensaver"
  homepage "https://github.com/pipeseroni/pipes.sh"
  url "https://github.com/pipeseroni/pipes.sh/archive/v1.3.0.tar.gz"
  sha256 "532976dd8dc2d98330c45a8bcb6d7dc19e0b0e30bba8872dcce352361655a426"
  head "https://github.com/pipeseroni/pipes.sh.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c56e69b2b8c9ce8d5e32b5294b16b72c2a2f018787cf027924e03aac017eb70d" => :high_sierra
    sha256 "004117e5f0a3b676f3969324079418f69101322c8cf30d231d3f75f62da98eee" => :sierra
    sha256 "a9e6ad6ea1c6eb5d88b4f819b2980cb2ce89113913b58f5f68bba8b6ec6dc19e" => :el_capitan
    sha256 "a9e6ad6ea1c6eb5d88b4f819b2980cb2ce89113913b58f5f68bba8b6ec6dc19e" => :yosemite
  end

  depends_on "bash"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/pipes.sh -v").strip.split[-1]
  end
end
