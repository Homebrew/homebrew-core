class Libbpg < Formula
  desc "Image format meant to improve on JPEG quality and file size"
  homepage "https://bellard.org/bpg/"
  url "https://bellard.org/bpg/libbpg-0.9.8.tar.gz"
  sha256 "c0788e23bdf1a7d36cb4424ccb2fae4c7789ac94949563c4ad0e2569d3bf0095"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?libbpg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_ventura:  "6efc300826fc1217ec39625cd01b93617fb9ea95f11a88c990751fed2e27eabb"
    sha256 cellar: :any, arm64_monterey: "6a4d3e8d365795072c819aaca5b6e662e047b80ebe05b555a8f0fb1e6d898ad7"
    sha256 cellar: :any, arm64_big_sur:  "d83f7a8c9da692ea920d82e7a3f67708525e719133b69175343087aa71ceadc0"
    sha256 cellar: :any, monterey:       "54e0eb081753ff784595e6df85d47e691481cdf05101c3e7f8032aca9ae61024"
    sha256 cellar: :any, big_sur:        "193409ef7e3a3ad3a2913a075b9d53a6aa1aa8d45ddb7ce299dd660fa6d67c66"
    sha256 cellar: :any, catalina:       "f7d21d83158c5122b604bbe9641014628257dbc754fdc66ebf2ffc237bdd9893"
  end

  depends_on "cmake" => :build
  depends_on "yasm" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"

  def install
    bin.mkpath
    extra_args = []
    extra_args << "CONFIG_APPLE=y" if OS.mac?
    system "make", "install", "prefix=#{prefix}", *extra_args
    pkgshare.install Dir["html/bpgdec*.js"]
  end

  test do
    system bin/"bpgenc", test_fixtures("test.png")
    assert_predicate testpath/"out.bpg", :exist?
  end
end
