class Empty < Formula
  desc "Lightweight Expect-like PTY tool for shell scripts"
  homepage "https://empty.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/empty/empty/empty-0.6.21b/empty-0.6.21b.tgz"
  sha256 "2fccd0faa1b3deaec1add679cbde3f34250e45872ad5df463badd4bb4edeb797"
  license "BSD-3-Clause"

  def install
    system "make", "all"
    system "make", "PREFIX=#{prefix}", "install"
    rm_rf "#{prefix}/man"
    man1.install "empty.1"
    pkgshare.install "examples"
  end

  test do
    (testpath/"test.sh").write <<~EOS
      #!/bin/bash
      empty -f -i in -o out -p test.pid cat
      empty -s -o in "Hello, world\n"
      empty -w -i out -o in ", world" "We have liftoff!\n"
      empty -w -i out -o in "liftoff!"
      empty -k `cat test.pid`
    EOS
    system "bash", "test.sh"
  end
end
