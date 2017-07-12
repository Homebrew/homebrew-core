class Gifsicle < Formula
  desc "GIF image/animation creator/editor"
  homepage "https://www.lcdf.org/gifsicle/"
  url "https://www.lcdf.org/gifsicle/gifsicle-1.89.tar.gz"
  sha256 "15b4cd27fff502c3769c245f71ed5484a38efd3f15106714a65db3a21b066f3e"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f36e4e772117c0a8b54f61e6186a3c77f09091728890f817fd779b05d357978" => :sierra
    sha256 "8a9f1a6685f096bce9db192c9ecb7e27bcdb3d520e5d583a2bc4529292a40a18" => :el_capitan
    sha256 "0248e063028fc460eba873bb8c2b963db5a6f6e6b51a4d9d73639a781728f0aa" => :yosemite
  end

  head do
    url "https://github.com/kohler/gifsicle.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-x11", "Install gifview"

  depends_on :x11 => :optional

  conflicts_with "giflossy",
    :because => "both install an `gifsicle` binary"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--disable-gifview" if build.without? "x11"

    system "./bootstrap.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/gifsicle", "--info", test_fixtures("test.gif")
  end
end
