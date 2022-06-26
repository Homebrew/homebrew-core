class Base64 < Formula
  desc "Encode and decode base64 files"
  homepage "https://www.fourmilab.ch/webtools/base64/"
  url "https://www.fourmilab.ch/webtools/base64/base64-1.5.tar.gz"
  sha256 "2416578ba7a7197bddd1ee578a6d8872707c831d2419bdc2c1b4317a7e3c8a2a"

  livecheck do
    url :homepage
    regex(/href=.*?base64[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa86de79c32e57cf11fceeba4ab6ccdbd4bccbf88704e85b7f9bae100f9af236"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddaa699165e82146b4f3b476d05cff364a9530d1c389d43573b8f59a2a2e7d5a"
    sha256 cellar: :any_skip_relocation, monterey:       "283b796362540fd1f3a006f537bc87c92cfe1c47071eb8d2d2c863334ada81d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c9e32d24df53a042aec56518070159c224216e16346f7f567a4261521609efd"
    sha256 cellar: :any_skip_relocation, catalina:       "f883e1602433f3a921fd1892747d76cf4548f75ac2e572be9eb0cfe0ced7290c"
    sha256 cellar: :any_skip_relocation, mojave:         "790e40a7ee037b0b99cc63d2085b121893ba80dfb43465c380568e7bacf3f83a"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c3a8113c031b07426e6eda7da7604db9308999f456eeca5f3f2d5c8d85ba3a0d"
    sha256 cellar: :any_skip_relocation, sierra:         "3cd13d14c225413a5bc3b24f8f5dab48c2a942b64bf9162ad3a8ea8320a74bd1"
    sha256 cellar: :any_skip_relocation, el_capitan:     "0ab522634adf5c9eefb08c11d51d2b6e0477d8ea607afdb8eefe204de764f180"
    sha256 cellar: :any_skip_relocation, yosemite:       "5681332029a2ed1fe1272b2ef9877a6348501897822c6a8955b26bb904426b1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f8f96bcf972f99b8ca838f542a44c9b1f7bf8da7e66eb3333d941093ecbc199"
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
