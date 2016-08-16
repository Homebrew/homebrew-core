class Jpegoptim < Formula
  desc "Utility to optimize JPEG files"
  homepage "https://github.com/tjko/jpegoptim"
  url "https://github.com/tjko/jpegoptim/archive/RELEASE.1.4.4.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/j/jpegoptim/jpegoptim_1.4.4.orig.tar.gz"
  sha256 "bc6b018ae8c3eb12d07596693d54243e214780a2a2303a6578747d3671f45da3"
  head "https://github.com/tjko/jpegoptim.git"

  bottle do
    cellar :any
    sha256 "1b666f4c77a2f553e4802a24818a7f8aabf87fc89f574e516cfc4fe1eeea9779" => :el_capitan
    sha256 "a96c668146e37bb303f0684b3395791926a22331a85e1e14b906510016e2dcf3" => :yosemite
    sha256 "4628860044aff9a7adc4106ea702aed3dfee8e8c5f2192d03130a55b7dd8a49d" => :mavericks
  end

  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.j1 # Install is not parallel-safe
    system "make", "install"
  end

  test do
    source = test_fixtures("test.jpg")
    assert_match "OK", shell_output("#{bin}/jpegoptim --noaction #{source}")
  end
end
