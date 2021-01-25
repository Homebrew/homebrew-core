class LibpthreadStubs < Formula
  desc "X.Org: pthread-stubs.pc"
  homepage "https://www.x.org/"
  url "https://xcb.freedesktop.org/dist/libpthread-stubs-0.4.tar.bz2"
  sha256 "e4d05911a3165d3b18321cc067fdd2f023f06436e391c6a28dff618a78d2e733"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "959dcecc35db3faf40e18ac1fe4350b034a552a32c2b2d5a9e9c8570b8626a90" => :big_sur
    sha256 "66f717674d23f63fae9357bc6432f98c9e40702a1112af2b65ba4b3b22ed3192" => :arm64_big_sur
    sha256 "4d69c165836f4d19d4afd152f02340ea1f6e3f218faf950dddca39e10553c80d" => :catalina
    sha256 "1baaf595e397cbfa6ba2379e1080d39de10115c39be797476cf89ff33b85938f" => :mojave
    sha256 "52d34ffb143025031355dcc9e9d4c64fe5cd46f020f2c3861fdc26d1f9c759d6" => :high_sierra
  end

  depends_on "pkg-config"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "pkg-config", "--exists", "pthread-stubs"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
