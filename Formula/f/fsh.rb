class Fsh < Formula
  desc "FreeBSD sh(1) ported to macOS — Bourne-lineage shell with faithful echo"
  homepage "https://github.com/dotike/freebsd-sh-macos"
  url "https://github.com/dotike/freebsd-sh-macos/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "aafd630a6c100334bad1a55eb81abb5d0ec05168e213b1948eb5be22ce7187fe"
  license "BSD-2-Clause"

  depends_on "libedit"
  depends_on :macos

  def install
    system "make", "LIBEDIT_PREFIX=#{Formula["libedit"].opt_prefix}",
                   "PREFIX=#{prefix}"
    system "make", "install", "LIBEDIT_PREFIX=#{Formula["libedit"].opt_prefix}",
                              "PREFIX=#{prefix}"
  end

  test do
    # echo must be faithful: no escape interpretation
    assert_equal "hello\\nworld",
      shell_output("#{bin}/fsh -c 'echo \"hello\\nworld\"'").strip
  end
end
