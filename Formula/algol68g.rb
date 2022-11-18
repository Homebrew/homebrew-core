class Algol68g < Formula
  desc "Algol 68 compiler-interpreter"
  homepage "https://jmvdveer.home.xs4all.nl/algol.html"
  # The upstream download url currently returns a 404 error.
  # Until fixed, we can use a copy from OpenBSD.
  url "https://ftp.openbsd.org/pub/OpenBSD/distfiles/algol68g-2.8.5.tar.gz"
  mirror "https://jmvdveer.home.xs4all.nl/algol68g-2.8.5.tar.gz"
  sha256 "0f757c64a8342fe38ec501bde68b61d26d051dffd45742ca58b7288a99c7e2d8"
  license "GPL-3.0-or-later"
  revision 1

  # The homepage hasn't been updated for the latest release (2.8.5), even though
  # the related archive is available on the site. Until the website is updated
  # (and seems like it will continue to be updated for new releases), we're
  # checking a third-party source for new releases as an interim solution.
  livecheck do
    url "https://openports.se/lang/algol68g"
    regex(/href=.*?algol68g[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "767d41993bc543b9701cebb0017edd868373ad02f049dec77b87002ea19c3ed9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fb1d792d8f777ca08e22372c092a74ac6db17225fd5f110e516b891a02ceeec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c0bde6c0a8205ec17f4d9a6c8084da44ec9c99beaf09eb7f4184042fcca2818"
    sha256                               ventura:        "89660d0a2a30c4f7f6101449e4ecf48881ae986bc2bf8b57c3181c9084e193ad"
    sha256                               monterey:       "90017642701aa5b8c7cc9bf49937dcd0efdd75a7d25792aa4f6bdbef30ac98b6"
    sha256                               big_sur:        "14b3262c6aff2d74889e253bf8bf5dd132bd1ff5ed3847b4f6e5e5e7c8728913"
    sha256                               catalina:       "38110a685728de5d40abb532e6e295d4a13cc55cc6a4d3357c66ff5ef031513e"
    sha256                               x86_64_linux:   "849e07720d6bd959b0eb91073395850d91f97e9cd94ccd07c19a32db765916cb"
  end

  on_linux do
    depends_on "libpq"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    path = testpath/"hello.alg"
    path.write <<~EOS
      print("Hello World")
    EOS

    assert_equal "Hello World", shell_output("#{bin}/a68g #{path}").strip
  end
end
