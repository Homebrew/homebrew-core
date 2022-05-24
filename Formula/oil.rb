class Oil < Formula
  desc "Bash-compatible Unix shell with more consistent syntax and semantics"
  homepage "https://www.oilshell.org/"
  url "https://www.oilshell.org/download/oil-0.10.1.tar.gz"
  sha256 "c55c34a52f13eb93d4888612d95dcb451a19e474d6acd75197be055fe020593c"
  license "Apache-2.0"

  livecheck do
    url "https://www.oilshell.org/releases.html"
    regex(/href=.*?oil[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "ee58b907165b2183c9348071508583d59f712c428b630727ce74062b66f2a2f6"
    sha256 arm64_big_sur:  "603c6aa8b63a5d4bab17499313f62fe0887a22a56be61044ffa96d7e57704b4e"
    sha256 monterey:       "19467a4aad0650ec6cb8522e2bfffe2580c46a9234c8e33ff202114389f550ef"
    sha256 big_sur:        "ed6cf7fc84dba5a01a3372ee3ef25307a4255110c64af723f759959413c6b2d9"
    sha256 catalina:       "10d8baf4fe5ececcc587334898fda8f024ff4fa302c1fd46bdc4de90d70fab42"
    sha256 x86_64_linux:   "21a5dd219432223f1c968d2fb55f1786d96ebf5c2bfa3f198b9943037c183578"
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

    system "#{bin}/oil", "-c", "shopt -u parse_equals"
    assert_equal "bar", shell_output("#{bin}/oil -c 'var foo = \"bar\"; write $foo'").strip
  end
end
