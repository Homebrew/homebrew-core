class GitImerge < Formula
  desc "Incremental merge for git"
  homepage "https://github.com/mhagger/git-imerge"
  url "https://github.com/mhagger/git-imerge/archive/v1.0.0.tar.gz"
  sha256 "2ef3a49a6d54c4248ef2541efc3c860824fc8295a7226760f24f0bb2c5dd41f2"
  head "https://github.com/mhagger/git-imerge.git"

  bottle do
    cellar :any_skip_relocation
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
