class Nnn < Formula
  desc "Free, fast, friendly file browser"
  homepage "https://github.com/jarun/nnn"
  url "https://github.com/jarun/nnn/archive/v1.7.tar.gz"
  sha256 "fbe26efbed8b467352f313b92f8617d873c8cf0209fb6377572cf8d1ddc2747c"

  bottle do
    cellar :any
    sha256 "bb763df644735027c3461bb423b381418266ec70eaac20d457be87445b1d94aa" => :high_sierra
    sha256 "bfb3e43e95ffe9ba3e601ad02a7aa4f1ecb313a472b22b415288c00e3d740678" => :sierra
    sha256 "813fbdb127710d374d7121f380ac58e4f49cf044495529981d1b99ef98cba0a6" => :el_capitan
  end

  depends_on "readline"

  # Upstream PR from 27 Feb 2018 "Makefile: don't use non-portable -t option"
  patch do
    url "https://github.com/jarun/nnn/pull/83.patch?full_index=1"
    sha256 "e3196f69407a81b19cd42c9fafb6b420d99ebeed592dd0948efbb9665a6c4a9f"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    # Testing this curses app requires a pty
    require "pty"
    PTY.spawn(bin/"nnn") do |r, w, _pid|
      w.write "q"
      assert_match testpath.realpath.to_s, r.read
    end
  end
end
