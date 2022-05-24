class Lzop < Formula
  desc "File compressor"
  homepage "https://www.lzop.org/"
  url "https://www.lzop.org/download/lzop-1.04.tar.gz"
  sha256 "7e72b62a8a60aff5200a047eea0773a8fb205caf7acbe1774d95147f305a2f41"
  license "GPL-2.0"

  livecheck do
    url "https://www.lzop.org/download/"
    regex(/href=.*?lzop[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "32f4ffb33fda5a32802c7a37dcf41eef9b74185e726c6332912dc7d0d524381a"
    sha256 cellar: :any,                 arm64_big_sur:  "32390eb8141791296e84ed7c6a39edb5bb2ded9b04581c301d32a6dfa322db4d"
    sha256 cellar: :any,                 monterey:       "5a74762d3592fc992174fff54cb221db8a4c104f185ac3eff12deda7e97563be"
    sha256 cellar: :any,                 big_sur:        "f04a876a2b69220632fb027546104d9c6cb9ee8bdb1d9f6a2845a054500d8bb7"
    sha256 cellar: :any,                 catalina:       "3aa57a50254d383c0fe0e4d0d0585e1525d50d0cd30f87390d087523348044a0"
    sha256 cellar: :any,                 mojave:         "0ec93aa163500d45c456bce3ee100dbe61c4db080494ee41383286ca10f4d246"
    sha256 cellar: :any,                 high_sierra:    "d42fafd3f1f39d9ab512f755bd216edd24002caf8a4da82f80818fe2c29f0556"
    sha256 cellar: :any,                 sierra:         "73c2ce334be9317ca79509aec3acef2fa1eff0ffb69fdc10b3850b7f51101f72"
    sha256 cellar: :any,                 el_capitan:     "26e49bf0d06fb60d7cd5c431634966f28993edc250c4d06b0db26b28aae3cd0d"
    sha256 cellar: :any,                 yosemite:       "d9e12c4bb51c43dd306d5283fde5c3350e3e1f7f1d48c05c831a57b058db1354"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15ba7328bdcb1e9789b03851966efb4cd6ccc3feb35cfbc37a364be6fc4c77e7"
  end

  depends_on "lzo"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"test"
    text = "This is Homebrew"
    path.write text

    system "#{bin}/lzop", "test"
    assert_predicate testpath/"test.lzo", :exist?
    rm path

    system "#{bin}/lzop", "-d", "test.lzo"
    assert_equal text, path.read
  end
end
