class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20260619.tar.gz"
  sha256 "d93b0d6db72bc682ae983513c8e7d6574d53b5c76a09b487b35a391c8aaebb5a"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "840c9447c25c302d6428e77d8f56241cde03d5788ccdfcfbe49ea15f745523d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70fbe5d2f6e27f491a4af44baa67c2d16c6f748dcba3b8fae9fc262d7bd26b85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f63d8b009c125f0f412336d67ff4929f69b772676713c94055c9bf1f8dd07907"
    sha256                               sonoma:        "15cdacb61f2571477e99ab8e1473470b5e8eff501e7a68f1240f077d4cfa7476"
    sha256                               arm64_linux:   "8f20d324633ac87222cd1cbb19dac036a00f2b6b88d768ff34343e5c1f22bd82"
    sha256                               x86_64_linux:  "e8e2d5269fa9598e249b473caa7a959418830ef423883c662689c5729c1ffbe9"
  end

  uses_from_macos "bc-gh" => :build

  def install
    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    # shell-ksh test segfaults since macOS 11.
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install", "BROKEN_TESTS=shell-ksh"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~MAKE
      all: hello

      hello:
      	@echo 'Test successful.'

      clean:
      	rm -rf Makefile
    MAKE
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
