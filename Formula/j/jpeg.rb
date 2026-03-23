class Jpeg < Formula
  desc "Image manipulation library"
  homepage "https://www.ijg.org/"
  url "https://www.ijg.org/files/jpegsrc.v10.tar.gz"
  mirror "https://fossies.org/linux/misc/jpegsrc.v10.tar.gz"
  sha256 "8b9eaa13242690ebd03e1728ab1edf97a81a78ed6e83624d493655f31ac95ab5"
  license "IJG"

  livecheck do
    url "https://www.ijg.org/files/"
    regex(/href=.*?jpegsrc[._-]v?(\d+[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9c9a77dbf6f8e31baaf5fcf343a8ce66d368a98239d70395f151a92931965757"
    sha256 cellar: :any,                 arm64_sequoia: "bfff2e53bb277e547ff825933f99e02d8f8f38f42ca6d971f76ccfb09b4fd5f4"
    sha256 cellar: :any,                 arm64_sonoma:  "a89d936c43d5bede6e4cbbf13c4c5da7a44ac7487560dfbaac56b86e0e4027ac"
    sha256 cellar: :any,                 sonoma:        "ef3654b5d485d0e77cf5a7a06a9510b8f9c995e6df7566df10791ba25c61bf65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e84e7c9f5ec284afd4366e2f9830ed49d2dfda0e60bd433b6eb367a08d67d12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "32588e95a61f3c5d96dcf9b07c444dad100e0ef26df995d74c4cd93d5e119575"
  end

  keg_only "it conflicts with `jpeg-turbo`"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"djpeg", test_fixtures("test.jpg")
  end
end
