class Libvoikko < Formula
  desc "Linguistic software and Finnish dictionary"
  homepage "https://voikko.puimula.org/"
  url "https://www.puimula.org/voikko-sources/libvoikko/libvoikko-4.3.1.tar.gz"
  sha256 "368240d4cfa472c2e2c43dc04b63e6464a3e6d282045848f420d0f7a6eb09a13"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.puimula.org/voikko-sources/libvoikko/"
    regex(/href=.*?libvoikko[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "33d231fd79f10e19502f747b9d16bc40882407540b131041babbedee62f3b7aa"
    sha256 cellar: :any,                 arm64_big_sur:  "b0a624c9b02009d2eac3b6adbf6db56c05d6cde859ea5cef7b6a06973afd8619"
    sha256 cellar: :any,                 monterey:       "156a56c277dc6f56fb456f91258b3c75f82c852b08e54bda30a8d28791b53b31"
    sha256 cellar: :any,                 big_sur:        "02041f6b02bbdf49d1399b6c8b0f99e00a003a9f03bf13b57fe449759f98e27e"
    sha256 cellar: :any,                 catalina:       "ffc0a9565f9806e59b80b69523230d550a9c3cdfacf6d892a13a7c3b11ac428e"
    sha256 cellar: :any,                 mojave:         "79b5cb80a3e95beb1d57485d549724334d687dfdbc60520d3b437f5646ae756d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee79fddd0811eb6bd7622a0a9f7ab8319e5306c91bcd3b54eee92e92734f2a98"
  end

  depends_on "foma" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build
  depends_on "hfstospell"

  resource "voikko-fi" do
    url "https://www.puimula.org/voikko-sources/voikko-fi/voikko-fi-2.4.tar.gz"
    sha256 "320b2d4e428f6beba9d0ab0d775f8fbe150284fbbafaf3e5afaf02524cee28cc"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-dictionary-path=#{HOMEBREW_PREFIX}/lib/voikko"
    system "make", "install"

    resource("voikko-fi").stage do
      ENV.append_path "PATH", bin.to_s
      system "make", "vvfst"
      system "make", "vvfst-install", "DESTDIR=#{lib}/voikko"
      lib.install_symlink "voikko"
    end
  end

  test do
    assert_match "C: onkohan", pipe_output("#{bin}/voikkospell -m", "onkohan\n")
  end
end
