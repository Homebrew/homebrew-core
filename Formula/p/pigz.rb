class Pigz < Formula
  desc "Parallel gzip"
  homepage "https://zlib.net/pigz/"
  url "https://zlib.net/pigz/pigz-2.8.tar.gz"
  sha256 "eb872b4f0e1f0ebe59c9f7bd8c506c4204893ba6a8492de31df416f0d5170fd0"
  license "Zlib"
  head "https://github.com/madler/pigz.git", branch: "develop"

  livecheck do
    url :homepage
    regex(/href=.*?pigz[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "64097e66f14e0e16ab597007639492ac10e2d0f499968b757f91fa700f06f952"
    sha256 cellar: :any,                 arm64_sonoma:   "97752b6fd2b65df80d73068299789a714fb01b6b904fd843c142677e4f2c3db7"
    sha256 cellar: :any,                 arm64_ventura:  "ddd9fed16f07f42285d3a4a46b6d769f4ca2e902827dbd44a3f69597eca5cb77"
    sha256 cellar: :any,                 arm64_monterey: "043af6f4e17cb7776003f982331552ed3b6ce10a46fdce4687952fa9443fbab8"
    sha256 cellar: :any,                 arm64_big_sur:  "1f4b378d4427db80c89231ddf0ca710f11c6a300d36687b30025dcd263c9441e"
    sha256 cellar: :any,                 sonoma:         "cd7b739570e228afbea2ad719c4789607d41a441d6c03dd4115a97e67cae729c"
    sha256 cellar: :any,                 ventura:        "0d30f581ef66c28103ccec510b9df46f2cd761bc9f9ce76af0422b60256739f7"
    sha256 cellar: :any,                 monterey:       "0ef362a072b9e707ee292162d44d46a23e9f04c1e239d05f462d20fad9c8c1b2"
    sha256 cellar: :any,                 big_sur:        "cd36e7d4ec7c3f373a4e74f280ac1001aa834d035f20a3ec3a2e3140f75fd525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca1011cd83d5acec7b50fd581f4efa9d189c22058d652736f3dc565a0165c67b"
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
    assert_predicate testpath/"example.gz", :file?
    system bin/"unpigz", testpath/"example.gz"
    assert_equal test_data, (testpath/"example").read
    system "/bin/dd", "if=/dev/random", "of=foo.bin", "bs=1024k", "count=10"
    system bin/"pigz", "foo.bin"
  end
end
