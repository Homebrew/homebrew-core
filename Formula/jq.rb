class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://stedolan.github.io/jq/"
  url "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-1.5.tar.gz"
  sha256 "c4d2bfec6436341113419debf479d833692cc5cdab7eb0326b5a4d4fbe9f493c"

  bottle do
    cellar :any
    revision 2
    sha256 "4df3ac073164d99ecc20e6d0cdc363204ba992851fdd1f4a6d92eca3aae4671c" => :el_capitan
    sha256 "c09bf921664a2d9fe9a9c1dc19b739a1b8e92ffc67e5a833c95db6687a02c200" => :yosemite
    sha256 "6dc80e1c8032777ab107ec8ea650328cb3a9960d489877aa966924f533fee29f" => :mavericks
  end

  head do
    url "https://github.com/stedolan/jq.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "oniguruma" # jq depends > 1.5

  def install
    system "autoreconf", "-iv" unless build.stable?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-maintainer-mode",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/jq .bar", '{"foo":1, "bar":2}')
  end
end
