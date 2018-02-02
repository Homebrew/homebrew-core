class GitImerge < Formula
  desc "Incremental merge for git"
  homepage "https://github.com/mhagger/git-imerge"
  url "https://github.com/mhagger/git-imerge/archive/v1.1.0.tar.gz"
  sha256 "62692f43591cc7d861689c60b68c55d7b10c7a201c1026096a7efc771df2ca28"
  head "https://github.com/mhagger/git-imerge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ca6239030f398d92a18cd7973f886b34a6a136fa5506daa6b092b65e58ee0f0" => :high_sierra
    sha256 "fe6030bcaafa0b35d8137182f2b7fef2ff2d45f27a2b5d73aa251c88c70aa9d3" => :sierra
    sha256 "fe6030bcaafa0b35d8137182f2b7fef2ff2d45f27a2b5d73aa251c88c70aa9d3" => :el_capitan
    sha256 "fe6030bcaafa0b35d8137182f2b7fef2ff2d45f27a2b5d73aa251c88c70aa9d3" => :yosemite
  end

  def install
    bin.mkpath
    # Work around Makefile insisting to write to $(DESTDIR)/etc/bash_completion.d
    system "make", "install", "DESTDIR=#{prefix}", "PREFIX="
  end

  test do
    system bin/"git-imerge", "-h"
  end
end
