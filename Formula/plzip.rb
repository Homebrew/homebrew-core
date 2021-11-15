class Plzip < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/plzip.html"
  url "https://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.9.tar.gz"
  mirror "https://download-mirror.savannah.gnu.org/releases/lzip/plzip/plzip-1.9.tar.gz"
  sha256 "14d8d1db8dde76bdd9060b59d50b2943417eb4c0fbd2b84736546b78fab5f1a7"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.gnu.org/releases/lzip/plzip/"
    regex(/href=.*?plzip[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00894ac8632cd219e49242c93d4f0405d36358f084b74f64589e4be15e612e59"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d197045d0de19677e6ce0079afb3cfb94e54360aa2c00cda3bf5a74031e6b40"
    sha256 cellar: :any_skip_relocation, monterey:       "4ebdd421bc438eea1ffbd5e26a69418cde8483a164eaaf0698ae827bdde5c31a"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c79b456b6b1ea19d12efe0a1087f4b36092787a94cedacdfeb1186294e1f72b"
    sha256 cellar: :any_skip_relocation, catalina:       "9f278923d8c1d12bebbfa37b52816b85b8f4cc49e67ef7dc37de7ff1af9ea4ab"
    sha256 cellar: :any_skip_relocation, mojave:         "fe9addff91b4833212aa8107a92f1775af9cc7d5d96de1466917c3f0a51ee912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b54241076d7ac3e03f00823d18c069e9d52dbfaab3a0da8926e7ac955b055663"
  end

  depends_on "lzlib"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    text = "Hello Homebrew!"
    compressed = pipe_output("#{bin}/plzip -c", text)
    assert_equal text, pipe_output("#{bin}/plzip -d", compressed)
  end
end
