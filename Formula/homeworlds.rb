class Homeworlds < Formula
  desc "C++ framework for the game of Binary Homeworlds"
  homepage "https://github.com/Quuxplusone/Homeworlds/"
  url "https://github.com/Quuxplusone/Homeworlds.git",
      revision: "917cd7e7e6d0a5cdfcc56cd69b41e3e80b671cde"
  version "20141022"
  license "BSD-2-Clause"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c094bde41b9eeccc8c9d62b2e7e808f4ca9addfeb19f81a2e2e41f26f3871363"
    sha256 cellar: :any, big_sur:       "6b3e8e07aa49deb2996591fe781c0442f1812c8425665da5f83bb857428e57e4"
    sha256 cellar: :any, catalina:      "bc82b3b105c956df5e7f629c0ac69f29cb861992b2476a8228692f333f12854a"
    sha256 cellar: :any, mojave:        "85ac4667ac133f9a45870166c29a7c0dc1ed7cbb51216db987fb8601a001ebf6"
  end

  depends_on "wxwidgets"

  def install
    system "make"
    bin.install "wxgui" => "homeworlds-wx", "annotate" => "homeworlds-cli"
  end
end
