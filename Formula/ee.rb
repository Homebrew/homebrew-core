class Ee < Formula
  desc "Terminal (curses-based) text editor with pop-up menus"
  homepage "http://www.users.qwest.net/~hmahon/"
  url "http://www.users.qwest.net/~hmahon/sources/ee-1.4.6.src.tgz"
  sha256 "a85362dbc24c2bd0f675093fb593ba347b471749c0a0dbefdc75b6334a7b6e4c"

  bottle do
    cellar :any_skip_relocation
    sha256 "6ee6cda46ce7949176149637326332eedcf53e03d5e7fcd58759e5b173ef8fe4" => :sierra
    sha256 "3da2d595dec856251eb734ce0f12b5d04fd2c7354d48198c1014a923c63769ab" => :el_capitan
    sha256 "7cff46a098f916a37f45fa09799b79a204ba9866871413e596ab29295ece7b40" => :yosemite
    sha256 "b30c4ef2a49b136eb0912cad5ed4d36a954746c42aca3fb7d8197d827d8b3ff6" => :mavericks
  end

  def install
    system "make", "localmake"
    system "make", "all"

    # Install manually
    bin.install "ee"
    man1.install "ee.1"
  end

  test do
    ENV["TERM"] = "xterm"
    # escape + a + b is the exit sequence for `ee`
    pipe_output("#{bin}/ee", "\\033[ab", 0)
  end
end
