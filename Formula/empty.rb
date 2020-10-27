class Empty < Formula
  desc "Lightweight Expect-like PTY tool for shell scripts"
  homepage "https://empty.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/empty/empty/empty-0.6.21b/empty-0.6.21b.tgz"
  sha256 "2fccd0faa1b3deaec1add679cbde3f34250e45872ad5df463badd4bb4edeb797"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(%r{url=.*?/empty[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8eac558272ccf2338a374ea2e7158a4b0cf9008cc0111fefa8c85a80cfab2ee1" => :catalina
    sha256 "8fb4ab0e88893f107afe0e69a48ed6f257a11b370bd56b2237ecadec771e1a17" => :mojave
    sha256 "3c5daa156ad925469841f360ca2687011a96086f7d6c5b8af0fedea97ee059ca" => :high_sierra
  end

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
