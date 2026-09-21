class OilsForUnix < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://oils.pub/"
  url "https://oils.pub/download/oils-for-unix-0.38.0.tar.gz"
  sha256 "a33453722819b55ee552bfd7f3c2bab8f1940def55d5c8b46af16ce95bdf8803"
  license "Apache-2.0"

  livecheck do
    url "https://oils.pub/releases.html"
    regex(/href=.*?oils-for-unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9cbfb2000539d72a7f67e6baf5bb3850b501d1b9610c8627b08bffa18c9e84b6"
    sha256 cellar: :any, arm64_tahoe:       "c796e59f2e1a32dc30250d5af154aaf496c1978b9bdabecd3100b5be274ae546"
    sha256 cellar: :any, arm64_sequoia:     "e5fe474aaf7c63d3956c977a388bf6e3b358a077595a4a7a74f826279c1f193b"
    sha256 cellar: :any, arm64_linux:       "1aae8a6e3a3b95e6f3a5c3a6961f117f2b821f7fa53517a40bcab75bcdb83712"
    sha256 cellar: :any, x86_64_linux:      "cd7765d340396d4786c84166038eeb6d6b3a217eee2710615cbfca2c47001593"
  end

  depends_on "readline"

  conflicts_with "etsh", "omake", because: "both install 'osh' binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--datarootdir=#{share}",
                          "--readline=#{formula_opt_prefix("readline")}",
                          "--with-readline"
    system "_build/oils.sh"
    system "./install"
  end

  test do
    system bin/"osh", "-c", "shopt -q lastpipe"
    # Oils initialises readline on a TTY stdin, which stops shell_output's background process group with SIGTTOU
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system bin/"ysh", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/ysh -c 'var foo = \"bar\"; write $foo'").strip
  end
end
