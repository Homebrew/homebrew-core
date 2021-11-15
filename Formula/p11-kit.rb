class P11Kit < Formula
  desc "Library to load and enumerate PKCS#11 modules"
  homepage "https://p11-glue.freedesktop.org"
  url "https://github.com/p11-glue/p11-kit/releases/download/0.24.0/p11-kit-0.24.0.tar.xz"
  sha256 "81e6140584f635e4e956a1b93a32239acf3811ff5b2d3a5c6094e94e99d2c685"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 arm64_monterey: "5709b9c664f0e70a5b8ab1ae42d55c91f1e32cad67e2d0098e5cb4ba9b2915b1"
    sha256 arm64_big_sur:  "74df2e80935cbf3fd9f434d39787fab5f89ca1f4dc210c3dc002d2e8445c155d"
    sha256 monterey:       "9e2b637f208aba9e66ecfbde97884e236abaaa2a4c4aa56681c206425f350f52"
    sha256 big_sur:        "afd53d336262a0bb9983276eb6ea6b9c602a534d021dc9abc1f3ddfa20ec9869"
    sha256 catalina:       "37ee66ec71206a3077deef9d2f2452d0ea43a60d66a1d257a22947a189e115ea"
    sha256 mojave:         "8d25a20a23fbd9e5787369b86b2af53d1cb558e69de5f7f8ab25069ae7beb390"
    sha256 x86_64_linux:   "a8d4ad8b26dd3742a23afacba624ce409425e83b49b118a056f28d1e6fb96637"
  end

  head do
    url "https://github.com/p11-glue/p11-kit.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libffi"

  def install
    # https://bugs.freedesktop.org/show_bug.cgi?id=91602#c1
    ENV["FAKED_MODE"] = "1"

    if build.head?
      ENV["NOCONFIGURE"] = "1"
      system "./autogen.sh"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-trust-module",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--with-module-config=#{etc}/pkcs11/modules",
                          "--without-libtasn1"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/p11-kit", "list-modules"
  end
end
