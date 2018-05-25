class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v2.1.11.tar.gz"
  sha256 "ec943ed8217aef2b4c599c7c0bba5137a609961df4e114b486169a581b9a50b5"
  head "https://github.com/tj/n.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "36e2056f9a514f3d7b418d3bf96cfc3246c92159e4c490301d6264811742327f" => :high_sierra
    sha256 "36e2056f9a514f3d7b418d3bf96cfc3246c92159e4c490301d6264811742327f" => :sierra
    sha256 "36e2056f9a514f3d7b418d3bf96cfc3246c92159e4c490301d6264811742327f" => :el_capitan
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
