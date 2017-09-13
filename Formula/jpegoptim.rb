class Jpegoptim < Formula
  desc "Utility to optimize JPEG files"
  homepage "https://github.com/tjko/jpegoptim"
  url "https://github.com/tjko/jpegoptim/archive/RELEASE.1.4.4.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/j/jpegoptim/jpegoptim_1.4.4.orig.tar.gz"
  sha256 "bc6b018ae8c3eb12d07596693d54243e214780a2a2303a6578747d3671f45da3"
  revision 1
  head "https://github.com/tjko/jpegoptim.git"

  bottle do
    cellar :any
    sha256 "2d1ab7073255d2c4a67d224e9f39a22fd32111e47b9e289829df48bed8d567e1" => :sierra
    sha256 "8fa157cbed17cb04bd6784e316866e89e0962dde9e0939ad20c896feaf5dfa05" => :el_capitan
    sha256 "90276c07525f402cf5d9ba4cd55fd40fa5fc3f80e198e3d316605a6c236ee1e7" => :yosemite
  end

  depends_on "jpeg"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    ENV.deparallelize # Install is not parallel-safe
    system "make", "install"
  end

  test do
    source = test_fixtures("test.jpg")
    assert_match "OK", shell_output("#{bin}/jpegoptim --noaction #{source}")
  end
end
