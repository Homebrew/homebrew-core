class Fmdiff < Formula
  desc "Use FileMerge as a diff command for Subversion and Mercurial"
  homepage "https://github.com/brunodefraine/fmscripts"
  url "https://github.com/brunodefraine/fmscripts/archive/refs/tags/20150915.tar.gz"
  sha256 "45ead0c972aa8ff5b3f9cf1bcefbc069931fd8218b2e28ff76958437a3fabf96"
  license :public_domain
  head "https://github.com/brunodefraine/fmscripts.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "a2f4d1e3f09bde0fd9d7e7e146bf4f0709f94b67150a54991ff10959f85fa22a"
  end

  depends_on :macos
  depends_on :xcode # Needs FileMerge.app, which is part of Xcode.

  def install
    system "make"
    system "make", "DESTDIR=#{bin}", "install"
  end

  test do
    ENV.prepend_path "PATH", testpath

    # dummy filemerge script
    (testpath/"filemerge").write <<~SHELL
      #!/bin/sh
      echo "it works"
    SHELL

    chmod 0744, testpath/"filemerge"
    touch "test"

    assert_match "it works", shell_output("#{bin}/fmdiff test test")
  end
end
