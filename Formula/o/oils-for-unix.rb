class OilsForUnix < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://oils.pub/"
  url "https://oils.pub/download/oils-for-unix-0.36.0.tar.gz"
  sha256 "9b65fc7333708dc1dc777e8a6145ae868eac6fbe0c444a8b12bb6d6d29652902"
  license "Apache-2.0"

  livecheck do
    url "https://oils.pub/releases.html"
    regex(/href=.*?oils-for-unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d7e0f8dfa4ea6bf7fb83152f39594b4979d73fe69e7370c0f23c83913bfd812d"
    sha256 cellar: :any,                 arm64_sequoia: "b9aaea4300f60d8e00d2fe72cf9dcb1046bcd2bc96ccd0a781164f36d62452de"
    sha256 cellar: :any,                 arm64_sonoma:  "bb4d0db3e96bacb67d74dc94e914f05020361a6fbf14ee0d8a5cc2734143237d"
    sha256 cellar: :any,                 sonoma:        "a65690faa7fc18ce270df922dd399ba9a99198c855655b63a50888c75697f6ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66b798b406a9058d4f8a6df3aa3f0ef656ebc2bccbc4f590801ee65dfc3278e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad221c6faee54ae61e5a463456a56533f06ad8f498c0f207cfcd673f2e7ce89e"
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
    system bin/"osh", "-c", "shopt -q lastpipe"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system bin/"ysh", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/ysh -c 'var foo = \"bar\"; write $foo'").strip
  end
end
