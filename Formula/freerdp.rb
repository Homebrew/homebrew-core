class Freerdp < Formula
  desc "X11 implementation of the Remote Desktop Protocol (RDP)"
  homepage "https://www.freerdp.com/"
  revision 1

  stable do
    url "https://github.com/FreeRDP/FreeRDP/archive/1.0.2.tar.gz"
    sha256 "c0f137df7ab6fb76d7e7d316ae4e0ca6caf356e5bc0b5dadbdfadea5db992df1"

    patch do
      url "https://github.com/FreeRDP/FreeRDP/commit/1d3289.diff?full_index=1"
      sha256 "09628c01238615c425e35f287b46f100fddcc2e5fea0adc41416fecee8129731"
    end

    patch do
      url "https://github.com/FreeRDP/FreeRDP/commit/e32f9e.diff?full_index=1"
      sha256 "829ce02ff1e618a808d6d505b815168cdef9cf0012db25d5b8470657852be93b"
    end

    # https://github.com/FreeRDP/FreeRDP/pull/1682/files
    patch do
      url "https://gist.githubusercontent.com/bmiklautz/8832375/raw/ac77b61185d11aa69e5f6b5e88c0fa597c04d964/freerdp-1.0.2-osxversion-patch.diff"
      sha256 "2e8f68a0dbe6e2574dec3353e65a4f03d76a3398f8fac536fda08c24748aec2b"
    end
  end

  bottle do
    rebuild 1
    sha256 "fbe93dacf9d752070395f904bbbad1fdfcf9c88fc11fa7bc232cf1d47e63ae3f" => :mojave
    sha256 "d5a590f4fd4af84251a575a34fa636a8e09c40e9b6795dc17243a32ecd0d3c67" => :high_sierra
    sha256 "9c9b013c4a2b9b2c7eb7542d1b0094b531b8ebed7b88542ff95b775cab0be52c" => :sierra
  end

  head do
    url "https://github.com/FreeRDP/FreeRDP.git"
    depends_on :xcode => :build
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl" # no OpenSSL 1.1 support
  depends_on :x11

  def install
    cmake_args = std_cmake_args
    cmake_args << "-DWITH_X11=ON" << "-DBUILD_SHARED_LIBS=ON" if build.head?
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    success = `#{bin}/xfreerdp --version` # not using system as expected non-zero exit code
    details = $CHILD_STATUS
    if !success && details.exitstatus != 128
      raise "Unexpected exit code #{$CHILD_STATUS} while running xfreerdp"
    end
  end
end
