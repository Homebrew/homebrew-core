class OilsForUnix < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://oils.pub/"
  url "https://oils.pub/download/oils-for-unix-0.33.0.tar.gz"
  sha256 "1b0a89031d1c4d4302c51e253d7fbcd1d8b0131fcbd713372391376760ae9386"
  license "Apache-2.0"

  livecheck do
    url "https://oils.pub/releases.html"
    regex(/href=.*?oils-for-unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "300f3f962bdbe88e2c33cdf736ad3aa28460c89e782397213d9dd142bf110a2a"
    sha256 cellar: :any,                 arm64_sonoma:  "35bb8c7a9333d9e28efa9cac106aa5d7b7119496bf2151b4a8dbc0b5045a55dc"
    sha256 cellar: :any,                 arm64_ventura: "c9a6028e4f7ba1cde1eb9164f8b8209f00ccd108c7268f68422ed8673de280aa"
    sha256 cellar: :any,                 sonoma:        "6d888a2c2f7e05a0868bf060e510431ed79b1204db93298a198b99948a79d18f"
    sha256 cellar: :any,                 ventura:       "339c2c41b1e4d8bfccc7895c9a94f990c5bba831ec0bf262b9bc3576b0711b39"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5b9900e8af5b9e1f54df4e19246b7d67901b9ea25553a2246f08157d38abcea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae32ab40f33940f4d219b47d3925677294e94d5847abb7910f03021726eb70b7"
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
