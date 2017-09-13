class PipesSh < Formula
  desc "Animated pipes terminal screensaver"
  homepage "https://github.com/pipeseroni/pipes.sh"
  url "https://github.com/pipeseroni/pipes.sh/archive/v1.2.0.tar.gz"
  sha256 "cb1901ece366205698c8572ef897743d1fb8e3e51abd42d3946e7e30f0831dec"
  head "https://github.com/pipeseroni/pipes.sh.git"

  bottle do
    cellar :any_skip_relocation
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
