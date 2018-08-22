class Plzip < Formula
  desc "Data compressor"
  homepage "https://www.nongnu.org/lzip/plzip.html"
  url "https://download.savannah.gnu.org/releases/lzip/plzip/plzip-1.7.tar.gz"
  sha256 "95e22cdd98eb2f41bf4fb169530a5945aad2fec20c2e2284d597e77972baf2b7"

  bottle do
    cellar :any_skip_relocation
    sha256 "85137992bdd087a806159c860ca47685dc9633c82d2c7892bd149c50fbbadec5" => :mojave
    sha256 "af30afb47c2eb2b2392c4402fa4deaeb505d34bc1a9dbd31d25fed666cfdc6a9" => :high_sierra
    sha256 "4461870d7a81404b53b7aae5d73180cbb3677bf65e2b815808311ad0573e5494" => :sierra
    sha256 "69b750626b5cdd03b7b2c6b6e260d8ebe5caf99e2a712503743c085baece4d8a" => :el_capitan
  end

  depends_on "lzlib"

  # error: unknown type name 'pthread_mutex_t' and 'pthread_cond_t'
  # Reported 24 Nov 2017 to lzip-bug AT nongnu DOT org
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/68e2af8/plzip/pthread.diff"
    sha256 "9e6653248ade666922b353b362eda6383af73c85cd93936c70bd8257e027f2b1"
  end

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
