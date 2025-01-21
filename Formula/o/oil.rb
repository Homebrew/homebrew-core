class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.24.0.tar.gz"
  sha256 "f199f5384e72c53eeb8a159ee7ac1b92819adc13a6dc5644ccae33e7ceaa9c72"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "d83f409a0561c48d8a3d05a0d3ce1e89975fdf4fb99f678fc4a3e801fea4860f"
    sha256 arm64_sonoma:  "5952024bb52e3635cd5d6661b6c442b628698ba5721c13809de7837ae6a97e54"
    sha256 arm64_ventura: "db8b40d42bdcfb8033e4c4c2c8d45f3aa8e9272ccd2c441cdaacae678e59050b"
    sha256 sonoma:        "9be93a8e62ce0032a1e4f044925990a7d174bf744adf814cc5f321ea1e2b581f"
    sha256 ventura:       "6204da4afc98af8aed93fa1e12995bc62fd7489b9ef74f467e16e1058f5e3351"
  end

  depends_on "readline"

  conflicts_with "oils-for-unix", because: "both install 'osh' and 'ysh' binaries"
  conflicts_with "etsh", "omake", because: "both install 'osh' binaries"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--datarootdir=#{share}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make"
    system "./install"
  end

  test do
    system bin/"osh", "-c", "shopt -q parse_backticks"
    assert_equal testpath.to_s, shell_output("#{bin}/osh -c 'echo `pwd -P`'").strip

    system bin/"oil", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/oil -c 'var foo = \"bar\"; write $foo'").strip
  end
end
