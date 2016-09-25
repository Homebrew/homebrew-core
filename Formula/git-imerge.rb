class GitImerge < Formula
  desc "Incremental merge for git"
  homepage "https://github.com/mhagger/git-imerge"
  url "https://github.com/mhagger/git-imerge/archive/v1.0.0.tar.gz"
  sha256 "2ef3a49a6d54c4248ef2541efc3c860824fc8295a7226760f24f0bb2c5dd41f2"
  head "https://github.com/mhagger/git-imerge.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "9b7742de26a901cf873a9829c443443f3f06a3ada26aaa3d56e7b800b8f481fa" => :el_capitan
    sha256 "f4e97a9cab7626785cf3c60a64746d187e89dec23e2f3cb1de29c5f8ae2a8b47" => :yosemite
    sha256 "33ef64eb73b8748c18a0760ced72ddef026bd08b9fc06910f13565d0954826e2" => :mavericks
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
