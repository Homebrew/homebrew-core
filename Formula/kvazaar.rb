class Kvazaar < Formula
  desc "Ultravideo HEVC encoder"
  homepage "https://github.com/ultravideo/kvazaar"
  url "https://github.com/ultravideo/kvazaar/archive/v0.8.2.tar.gz"
  sha256 "1b9354a639ab6c902e974780b39112b5e75477205611f88b54562c895182b945"
  head "https://github.com/ultravideo/kvazaar.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a50a695243ea971c8ab2cb85358f3095128e52be588df7b609cbf22048fb58ef" => :el_capitan
    sha256 "1cf96786d4613d94b93a8091027ea9d14ae6c801d11996def7c4b408316032e6" => :yosemite
    sha256 "aa78c8fa2657ccac25a0c3ac30d7840f281ab8af8a59aafb8058a122090e1b97" => :mavericks
    sha256 "5fc3c49c10479539474539e1bee928f89a3586f1f44e2f346c3b6484ff6395d2" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "yasm" => :build

  resource "videosample" do
    url "https://samples.mplayerhq.hu/V-codecs/lm20.avi"
    sha256 "a0ab512c66d276fd3932aacdd6073f9734c7e246c8747c48bf5d9dd34ac8b392"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # download small sample and try to encode it
    resource("videosample").stage do
      system bin/"kvazaar", "-i", "lm20.avi", "--input-res", "16x16", "-o", "lm20.hevc"
      assert File.exist? "lm20.hevc"
    end
  end
end
