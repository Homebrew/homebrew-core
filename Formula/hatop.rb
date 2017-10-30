class Hatop < Formula
  desc "Interactive ncurses client for HAProxy"
  homepage "http://feurix.org/projects/hatop/"
  url "https://github.com/feurix/hatop/archive/v0.7.7.tar.gz"
  sha256 "497a28e484940bf2f6dd5919041d5d03025325a59e8f95f376f573db616ca35d"

  def install
    man1.install "man/hatop.1"
    bin.install "bin/hatop"
  end

  test do
    system bin/"hatop", "--version"
  end
end
