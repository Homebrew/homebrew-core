class Julius < Formula
  desc "Two-pass large vocabulary continuous speech recognition engine"
  homepage "https://github.com/julius-speech/julius"
  url "https://github.com/julius-speech/julius/archive/v4.5.tar.gz"
  sha256 "d6a087a8c55b656c018638b4d2f7e58c534d4aa87b4dda4dd8a200232dbd0161"

  bottle do
    cellar :any
    sha256 "fc49c2e77d7e519c907e78bff4b82d837587dab76d6fda385ed5e12f398ce60d" => :mojave
    sha256 "913f7e63304c528b80f7fbef8163e3910c126fd4a4482a01106359d08510ae2b" => :high_sierra
    sha256 "c337a9f5efba5180d03ee10427e38516c12a488e8e58869570ced6c0e7480f89" => :sierra
    sha256 "9f5572a2ada2fdfdc38698b22efbbb523006c208fc3eb90346849fc658be5dd1" => :el_capitan
  end

  depends_on "libsndfile"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/julius --help", 1)
  end
end
