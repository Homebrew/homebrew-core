class Julius < Formula
  desc "Two-pass large vocabulary continuous speech recognition engine"
  homepage "https://github.com/julius-speech/julius"
  url "https://github.com/julius-speech/julius/archive/v4.5.tar.gz"
  sha256 "d6a087a8c55b656c018638b4d2f7e58c534d4aa87b4dda4dd8a200232dbd0161"

  bottle do
    cellar :any
    sha256 "f336509726e71d8e0a2b0588d8d84833934d75193168e133dd9b647f7cc775e5" => :catalina
    sha256 "c21148f0df6124ddb3f790bd2283971dcbac0f56e6679e2fdc8ebbfa0d025a39" => :mojave
    sha256 "10b892fb25a00b80bece10ab1bf218f6fad4466d9c5ddc5395ddcf9e6a40df73" => :high_sierra
    sha256 "c49edc3178b6d6582a0a82fa3b172acdf7ab7c4b275011853341fa17651ead5f" => :sierra
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
