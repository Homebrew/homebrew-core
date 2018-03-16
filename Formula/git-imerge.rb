class GitImerge < Formula
  desc "Incremental merge for git"
  homepage "https://github.com/mhagger/git-imerge"
  url "https://github.com/mhagger/git-imerge/archive/v1.1.0.tar.gz"
  sha256 "62692f43591cc7d861689c60b68c55d7b10c7a201c1026096a7efc771df2ca28"
  head "https://github.com/mhagger/git-imerge.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "76aee24eeb5e7615e4cfbd7aaf3aacac8d8729dfcee79d8542a84cbd9b663459" => :high_sierra
    sha256 "76aee24eeb5e7615e4cfbd7aaf3aacac8d8729dfcee79d8542a84cbd9b663459" => :sierra
    sha256 "76aee24eeb5e7615e4cfbd7aaf3aacac8d8729dfcee79d8542a84cbd9b663459" => :el_capitan
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
