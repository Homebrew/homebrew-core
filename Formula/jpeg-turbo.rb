class JpegTurbo < Formula
  desc "JPEG image codec that aids compression and decompression"
  homepage "https://www.libjpeg-turbo.org/"
  url "https://downloads.sourceforge.net/project/libjpeg-turbo/1.5.3/libjpeg-turbo-1.5.3.tar.gz"
  sha256 "b24890e2bb46e12e72a79f7e965f409f4e16466d00e1dd15d93d73ee6b592523"

  bottle do
    cellar :any
    sha256 "f40b0fe6a775f787436bace3e201c0cd9b441fe24c64093c948ddc369e94b0fd" => :high_sierra
    sha256 "0a499d6cc6e1de389154fb0d859fe2def77a973c629125ac8c783cb872e055db" => :sierra
    sha256 "6912770fdaefa0941c3259cbec3abf670ba8b6067239fde276686ed610599dda" => :el_capitan
  end

  devel do
    url "https://github.com/libjpeg-turbo/libjpeg-turbo/archive/1.5.90.tar.gz"
    sha256 "cb948ade92561d8626fd7866a4a7ba3b952f9759ea3dd642927bc687470f60b7"

    depends_on "cmake" => :build
  end

  head do
    url "https://github.com/libjpeg-turbo/libjpeg-turbo.git"

    depends_on "cmake" => :build
  end

  keg_only "libjpeg-turbo is not linked to prevent conflicts with the standard libjpeg"

  option "without-test", "Skip build-time checks (Not Recommended)"

  depends_on "nasm" => :build

  def install
    if build.stable?
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{prefix}",
                            "--with-jpeg8"
    else
      system "cmake", ".", "-DWITH_JPEG8=1", *std_cmake_args
    end

    system "make"
    system "make", "test" if build.with? "test"
    system "make", "install"
  end

  test do
    system "#{bin}/jpegtran", "-crop", "1x1", "-transpose", "-perfect",
                              "-outfile", "out.jpg", test_fixtures("test.jpg")
  end
end
