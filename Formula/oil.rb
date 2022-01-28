class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.9.7.tar.gz"
  sha256 "5c0574bd8926914edf5d8b0c29e7a39f83ce8be81c11c35c8ff5213d79a03426"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "8dc73b3c2671def851082815ee2b93d9d30c787c5d6f48252a78bdd6ddc4bf2b"
    sha256 arm64_big_sur:  "39d17d14b55f400f6e7560d6f9eb4fefcf89ffcd121b33422d2d9baca0e0fc41"
    sha256 monterey:       "eedd39016cb6a44a9ea52d9012792bd594e43fbf23be65556ba7340d68fe5fac"
    sha256 big_sur:        "23073ab908596b8a32cb3ae0d52f54b86a4871c57af594bde4ffe46ce1981808"
    sha256 catalina:       "300588adbeb8452122834db2584b687c75ca1dc159ea1a6cc595517211bc3dba"
    sha256 x86_64_linux:   "07ea363cee494095ade57862a5668f940f5258f2152f249f3e94bab87b3b1ede"
  end

  depends_on "readline"

  conflicts_with "omake", because: "both install 'osh' binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make"
    system "./install"
  end

  test do
    system "#{bin}/osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system "#{bin}/oil", "-c", "shopt -q parse_equals"
    assert_equal "bar", shell_output("#{bin}/oil -c 'var foo = \"bar\"; write $foo'").strip
  end
end
