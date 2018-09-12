class Picat < Formula
  desc "Simple, and yet powerful, logic-based multi-paradigm programming language"
  homepage "http://picat-lang.org"
  url "http://picat-lang.org/download/picat24_src.tar.gz"
  version "2.4.8"
  sha256 "72b452a8ba94d6187d837dcdb46aab0d7dc724651bac99a8cf2ada5c0a3543dd"
  depends_on "gcc" => :build

  def install
    inreplace "emu/Makefile.picat.mac64", "/usr/local/bin/gcc", HOMEBREW_PREFIX/"bin/gcc-8"
    system "make", "-C", "emu", "-f", "Makefile.picat.mac64"
    prefix.install Dir["doc", "emu", "exs", "lib"]
  end

  def post_install
    ln_sf prefix/"emu/picat_macx", HOMEBREW_PREFIX/"bin/picat"
  end

  test do
    system "#{HOMEBREW_PREFIX}/bin/picat", "#{prefix}/exs/euler/p1.pi"
  end
end
