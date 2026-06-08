class Fsh < Formula
  desc "FreeBSD sh(1) ported to macOS — Bourne-lineage shell with faithful echo"
  homepage "https://github.com/dotike/fsh"
  url "https://github.com/dotike/fsh/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "d5558cd419c8d46bdc958064cb97f963d1ea793866414c025906ec15033512ed"
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
