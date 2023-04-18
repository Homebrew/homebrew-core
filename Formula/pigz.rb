class Pigz < Formula
  desc "Parallel gzip"
  homepage "https://zlib.net/pigz/"
  url "https://zlib.net/pigz/pigz-2.7.tar.gz"
  sha256 "b4c9e60344a08d5db37ca7ad00a5b2c76ccb9556354b722d56d55ca7e8b1c707"
  license "Zlib"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?pigz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "02afde85821d63d31ef189f4e93a26f431ed649e4d8715975f673cdd21468070"
    sha256 cellar: :any,                 arm64_monterey: "f40d1f626296ecdb179a190453a4da78c7c435050af09b1a53f87b1bea300b17"
    sha256 cellar: :any,                 arm64_big_sur:  "180262f7c12c864db915febe813113b1ece1ab32be08c71584ad3f9871db6d0c"
    sha256 cellar: :any,                 ventura:        "2d5f69c5828d38b9dcc5b4e07060f064f8b740c2b62431dcb037b1268850cd9f"
    sha256 cellar: :any,                 monterey:       "7e224864ecdb1a168d106dfb1513d157bdceb96d9b7128b2dee2c09dc54b7995"
    sha256 cellar: :any,                 big_sur:        "f198953b4dd30c2a1f94e15a5eeaaa3a08f939aabd9e1677e0084280854bd84a"
    sha256 cellar: :any,                 catalina:       "aed8ea6e7144a01303be662196ddbe47f170a3106e04fca51a452319fac6a422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2be1ff19dbddcea217e2f2c8d45cd6d288ee379c099cf6c3b69b8eaa0157b52"
  end

  depends_on "zopfli"
  uses_from_macos "zlib"

  def install
    libzopfli = Formula["zopfli"].opt_lib/shared_library("libzopfli")
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "ZOP=#{libzopfli}"
    bin.install "pigz", "unpigz"
    man1.install "pigz.1"
    man1.install_symlink "pigz.1" => "unpigz.1"
  end

  test do
    test_data = "a" * 1000
    (testpath/"example").write test_data
    system bin/"pigz", testpath/"example"
    assert (testpath/"example.gz").file?
    system bin/"unpigz", testpath/"example.gz"
    assert_equal test_data, (testpath/"example").read
    system "/bin/dd", "if=/dev/random", "of=foo.bin", "bs=1024k", "count=10"
    system bin/"pigz", "foo.bin"
  end
end
