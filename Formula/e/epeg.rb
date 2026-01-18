class Epeg < Formula
  desc "JPEG/JPG thumbnail scaling"
  homepage "https://github.com/mattes/epeg"
  url "https://github.com/mattes/epeg/archive/refs/tags/v0.9.3.tar.gz"
  sha256 "efcd7e72c530c3ff46f9efd86ec1dbb042e4a55fc5a7ea75e6ade9f83cf77ba3"
  license "MIT-enna"
  head "https://github.com/mattes/epeg.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "b3d13a2831b4be8bb1314371dd6bdc343309fcd125083e6634f3ed55932914c6"
    sha256 cellar: :any,                 arm64_sequoia:  "f76fb3cb8de88a494ad312352ac1cf1c34091c19f042ff330ff9bcd0ec8ea47c"
    sha256 cellar: :any,                 arm64_sonoma:   "a75e74989ce84ab632a526be0e13096687ad08b7204139d3dae623435446dbb9"
    sha256 cellar: :any,                 arm64_ventura:  "dc12942fff332ba2c9848f81f18fc7841f6eaacf577fa5fbdd1614dd0ca2d830"
    sha256 cellar: :any,                 arm64_monterey: "1f3486392ac95bb6bf814dc349c22e0fc7dcbe5152db567862545fc3d1ead791"
    sha256 cellar: :any,                 arm64_big_sur:  "8846517d51a4753177fb10b45bf3e2998952203ae8c4c6f7fa320d852f870e94"
    sha256 cellar: :any,                 sonoma:         "8b9e05f577cb02c5b9e0e38826b3e0d4f7ebcdf4c0a2a79f8a024c809174af36"
    sha256 cellar: :any,                 ventura:        "2b416c133f210e7dfe26b7aa956b5bbc13a1549d229b5b35a6961f1ce93abaea"
    sha256 cellar: :any,                 monterey:       "0cbf899c73a395d1a7dcc165231cf0153cfefffd59b3cab5920b13fcf82821b9"
    sha256 cellar: :any,                 big_sur:        "17c7e940618bf68ed137078379b02217676fbda4131688cfee6a4e970715174d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ddfd2af17fcd9a2ed038e1aaef0ca0ebf1cf272b5bd83720cfc866a875ab4c07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f45862529530f078589482b8f997ca5e2c7028ab1efd32c193eb9244bcc042a9"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "jpeg-turbo"
  depends_on "libexif"

  def install
    system "./autogen.sh", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"epeg", "--width=1", "--height=1", test_fixtures("test.jpg"), "out.jpg"
    assert_path_exists testpath/"out.jpg"
  end
end
