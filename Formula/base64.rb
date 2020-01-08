class Base64 < Formula
  desc "Encode and decode base64 files"
  homepage "https://www.fourmilab.ch/webtools/base64/"
  url "https://www.fourmilab.ch/webtools/base64/base64-1.5.tar.gz"
  sha256 "2416578ba7a7197bddd1ee578a6d8872707c831d2419bdc2c1b4317a7e3c8a2a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f883e1602433f3a921fd1892747d76cf4548f75ac2e572be9eb0cfe0ced7290c" => :catalina
    sha256 "790e40a7ee037b0b99cc63d2085b121893ba80dfb43465c380568e7bacf3f83a" => :mojave
    sha256 "c3a8113c031b07426e6eda7da7604db9308999f456eeca5f3f2d5c8d85ba3a0d" => :high_sierra
    sha256 "3cd13d14c225413a5bc3b24f8f5dab48c2a942b64bf9162ad3a8ea8320a74bd1" => :sierra
    sha256 "0ab522634adf5c9eefb08c11d51d2b6e0477d8ea607afdb8eefe204de764f180" => :el_capitan
    sha256 "5681332029a2ed1fe1272b2ef9877a6348501897822c6a8955b26bb904426b1a" => :yosemite
    sha256 "42e0864be73790c541237c3a2d41183cf1baacad346cb16c97bd3576f5f50cfc" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    bin.install "base64"
    man1.install "base64.1"
  end

  test do
    path = testpath/"a.txt"
    path.write "hello"
    assert_equal "aGVsbG8=", shell_output("#{bin}/base64 #{path}").strip
  end
end
