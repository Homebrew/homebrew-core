class Faac < Formula
  desc "ISO AAC audio encoder"
  homepage "https://sourceforge.net/projects/faac/"
  url "https://github.com/knik0/faac/archive/refs/tags/1_30.tar.gz"
  sha256 "adc387ce588cca16d98c03b6ec1e58f0ffd9fc6eadb00e254157d6b16203b2d2"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1af7b3a977137c5e1a3a3e8466fcbeddfb77f7656b07e790530ed90c3f85b819"
    sha256 cellar: :any,                 arm64_monterey: "413a14d54cc48a4fd7ae0363438f8ef75c0f0e076a889d3484cb93afa4b464aa"
    sha256 cellar: :any,                 arm64_big_sur:  "0e3e4e7ac9a55ca918a495b7ae577fb89e7d575e8ae52d8a8f2fd989b56f38f1"
    sha256 cellar: :any,                 ventura:        "0cc0b9e690f4d687b4c531359f036e6f7bdd63fb20c19aab22ffb972917f8958"
    sha256 cellar: :any,                 monterey:       "5a59cfb676ba67e6386cc9d0a5726ef1546de461364f88a96d6eaa4ca664bf18"
    sha256 cellar: :any,                 big_sur:        "6b5f296f4cbf136daaf34236ad07b76f79aa4452eb2914efbd641a97aee2b5c9"
    sha256 cellar: :any,                 catalina:       "36620606b1b45f273e61ebaf4527b226a8fc586808c9570d69940da680af14a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb2acbc5251d69a81adf1481f2e2cf631fbc13b588b53c206f6c6e07819c6e00"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./bootstrap"
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"faac", test_fixtures("test.mp3"), "-P", "-o", "test.m4a"
    assert_predicate testpath/"test.m4a", :exist?
  end
end
