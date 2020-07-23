class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.11.4.tar.gz"
  sha256 "6c8cf677cd5bc9459b5bd795419804da73071d42ed695c2b82cd166206efbd47"
  license "MIT"
  head "https://github.com/clibs/clib.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "26f1ebdd9169e1921150b2286f643efbffcbb65630a45f8d5c35a6421eab20e0" => :catalina
    sha256 "6f6c1c922dc56b1b3c99d2021705799a4714f9c6e6dd83daddcb3b300b191b28" => :mojave
    sha256 "997100150595e54147ffb1fe2b006f0bec1e581e34779a9f42a2327037db6e0d" => :high_sierra
  end

  uses_from_macos "curl"

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
