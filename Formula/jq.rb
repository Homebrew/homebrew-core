class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://stedolan.github.io/jq/"
  url "https://github.com/stedolan/jq/releases/download/jq-1.5/jq-1.5.tar.gz"
  sha256 "c4d2bfec6436341113419debf479d833692cc5cdab7eb0326b5a4d4fbe9f493c"
  revision 1

  bottle do
    cellar :any
    sha256 "468a0a375aa532141ca7bb0eed2efab41db2e3dae84355aedb8886512d24c704" => :el_capitan
    sha256 "2b8562c46727d448b6d4eb6c034ac1ad6ee5e42430dfdff3f59596421bb32b72" => :yosemite
    sha256 "66971fb13cdad99dd2b672025b3c9dff80b060602aacb5b73db67600df8ba2bf" => :mavericks
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
