class OilsForUnix < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://oils.pub/"
  url "https://oils.pub/download/oils-for-unix-0.29.0.tar.gz"
  sha256 "34fdb53f1dbd2b8742ef74cd3a46d87abfcda18d0d645f29762c4fddb9a2b3ac"
  license "Apache-2.0"

  livecheck do
    url "https://oils.pub/releases.html"
    regex(/href=.*?oils-for-unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "458894469477f2983786c18e710fb7dcba117fca119fa663790dc7bcd87672ed"
    sha256 cellar: :any,                 arm64_sonoma:  "aabac2877de0025ec567ca0b7ee4fd5e2c027d7a95f20326f3637118ce2f5acd"
    sha256 cellar: :any,                 arm64_ventura: "277b088921164cc8a30de0ca14c997f4668b3bc72a869ff18bfabce0887cbc18"
    sha256 cellar: :any,                 sonoma:        "4d13d4d2d8333adaed0548b3b115197c2e60a63514d06f6e0fc22329a626693b"
    sha256 cellar: :any,                 ventura:       "c884e5a9dc13ffec8be12cc3aab1ebea5beb5651551a1c58a8310162ee6f7885"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16f179fc7f86eb971cf518be492415cf53e4786b9e4cf82e56279cb455513b81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e594b3ab097a968c7412e1e99d1b174df101bf9fcec02c5d4584d7040727c58"
  end

  depends_on "readline"

  conflicts_with "oil", because: "both install 'osh' and 'ysh' binaries"
  conflicts_with "etsh", "omake", because: "both install 'osh' binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--datarootdir=#{share}",
                          "--readline=#{Formula["readline"].opt_prefix}",
                          "--with-readline"
    system "_build/oils.sh"
    system "./install"
  end

  test do
    system bin/"osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system bin/"ysh", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/ysh -c 'var foo = \"bar\"; write $foo'").strip
  end
end
