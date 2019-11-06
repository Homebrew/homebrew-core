class Csvprintf < Formula
  desc "Command-line utility for parsing CSV files"
  homepage "https://github.com/archiecobbs/csvprintf"
  url "https://github.com/archiecobbs/csvprintf/archive/1.0.4.tar.gz"
  sha256 "022188ced570203d6084e6eab68f7ad96054a4ab8aa54db1857a8fd076280568"

  bottle do
    cellar :any_skip_relocation
    sha256 "528d28c7c771522232c9a46b696cab18458ae21252859037c4f1b92801496eb4" => :catalina
    sha256 "42e857e3fe76d351204fb76fd017a257f3362382af49f6c7c03e156af6bd5bb0" => :mojave
    sha256 "99340f4265ad7a952d3f4fdcce154a10e46c7c8c06979b9e7c5d5016810a8c87" => :high_sierra
    sha256 "236d5de27a77cadffa4cc014b9f2416b7d952f8cedb96ced98096f0bbdc928cb" => :sierra
    sha256 "79c0236e6eeb86a283831f3123430f700862d229bc0b5d64b0a0251d8832e092" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    ENV.append "LDFLAGS", "-liconv"
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "Fred Smith\n",
                 pipe_output("#{bin}/csvprintf -i '%2$s %1$s\n'", "Last,First\nSmith,Fred\n")
  end
end
