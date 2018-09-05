class Julius < Formula
  desc "Two-pass large vocabulary continuous speech recognition engine"
  homepage "https://github.com/julius-speech/julius"
  url "https://github.com/julius-speech/julius/archive/v4.4.2.1.tar.gz"
  sha256 "784730d63bcd9e9e2ee814ba8f79eef2679ec096300e96400e91f6778757567f"

  bottle do
    cellar :any
    sha256 "fc49c2e77d7e519c907e78bff4b82d837587dab76d6fda385ed5e12f398ce60d" => :mojave
    sha256 "913f7e63304c528b80f7fbef8163e3910c126fd4a4482a01106359d08510ae2b" => :high_sierra
    sha256 "c337a9f5efba5180d03ee10427e38516c12a488e8e58869570ced6c0e7480f89" => :sierra
    sha256 "9f5572a2ada2fdfdc38698b22efbbb523006c208fc3eb90346849fc658be5dd1" => :el_capitan
  end

  depends_on "libsndfile"

  # Upstream PR from 9 Sep 2017 "ensure pkgconfig directory exists during
  # installation"
  patch do
    url "https://github.com/julius-speech/julius/pull/73.patch?full_index=1"
    sha256 "b1d2d233a7f04f0b8f1123e1de731afd618b996d1f458ea8f53b01c547864831"
  end

  def install
    # Upstream issue "4.4.2.1 parallelized build fails"
    # Reported 10 Sep 2017 https://github.com/julius-speech/julius/issues/74
    ENV.deparallelize

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
