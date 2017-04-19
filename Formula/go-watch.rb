class GoWatch < Formula
  desc "Portable Go replacement for GNU watch"
  homepage "https://github.com/ostera/watch"

  url "https://github.com/ostera/watch/archive/0.2.2.tar.gz"

  version "0.2.2"
  sha256 "d2a06ca79b78e1b2d205a6bfb1cdc8747691d82a61d1e35a2f3c9ec8579e7fc2"

  head "https://github.com/ostera/watch.git"

  depends_on "go"

  conflicts_with "watch"

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "watch", "-v"
  end
end
