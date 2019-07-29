class Nq < Formula
  desc "Unix command-line queue utility"
  homepage "https://github.com/chneukirchen/nq"
  url "https://github.com/chneukirchen/nq/archive/v0.3.1.tar.gz"
  sha256 "8897a747843fe246a6f8a43e181ae79ef286122a596214480781a02ef4ea304b"
  head "https://github.com/chneukirchen/nq.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5b3f7b76cc79a5bc6d4a55e4fb3e018b08052dc7faa173300b1ddf2e16e6bee" => :mojave
    sha256 "a6d18f2d7f1fafd661a5d145599969707efe71969ccc6ac34593f3f60c59081a" => :high_sierra
    sha256 "0e8d6557f7713be4c1e5074ea909d36cd12e2e17d85a1c0a1141ac64f06953d3" => :sierra
    sha256 "67374f5db8a35f877a16e0fdbd313276fb269db81ce49e7654fb61fa865417cd" => :el_capitan
  end

  depends_on :macos => :yosemite

  def install
    system "make", "all", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/nq", "touch", "TEST"
    assert_match /exited with status 0/, shell_output("#{bin}/fq -a")
    assert_predicate testpath/"TEST", :exist?
  end
end
