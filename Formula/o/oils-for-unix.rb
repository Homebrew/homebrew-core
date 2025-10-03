class OilsForUnix < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://oils.pub/"
  url "https://oils.pub/download/oils-for-unix-0.35.0.tar.gz"
  sha256 "b0d1475a5d549786968786f47b15bf244e1d4c3bf9119c11714997b11f96fdca"
  license "Apache-2.0"

  livecheck do
    url "https://oils.pub/releases.html"
    regex(/href=.*?oils-for-unix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "17662ece4994d65b78936abde0c77bb99efbe29e421690b6bba058a3a0d68ff9"
    sha256 cellar: :any,                 arm64_sequoia: "9e3d0c41a9cbea527dc1b8c30218d7ec3f2a23282cada360177c4b94c92283d1"
    sha256 cellar: :any,                 arm64_sonoma:  "c8694276b8bd69d8b736e60b8d410e6e121e3c947ea90d617971b44d82b60622"
    sha256 cellar: :any,                 arm64_ventura: "2a075e8e1b9703f1e3f5d39f320670966e994a92330cea3c929fd97dfa3c0fa3"
    sha256 cellar: :any,                 sonoma:        "f254de3acb5da80a456aa515884bc176059bc5923d75f1cd80f811a049d0e4af"
    sha256 cellar: :any,                 ventura:       "b91d7564707d1339225380021bf71be7d508a9caa815816c84add9aa0b9ab4aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d8dd5bf7b7b567b5fd837e98d00b62e556b6820156d1574ef691c8ee4f8fa92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1ec29cf9b2a53735bb80f6d1c953bf6d72a15f944a156420b0a339eff5d5616"
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
