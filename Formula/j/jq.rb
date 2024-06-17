class Jq < Formula
  desc "Lightweight and flexible command-line JSON processor"
  homepage "https://jqlang.github.io/jq/"
  url "https://github.com/jqlang/jq/releases/download/jq-1.7.1/jq-1.7.1.tar.gz"
  sha256 "478c9ca129fd2e3443fe27314b455e211e0d8c60bc8ff7df703873deeee580c2"
  license "MIT"

  livecheck do
    url :stable
    regex(/^(?:jq[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "07bc9081c0fdb43aca089e5839f6a270fc45ca9aa7d7633e16fac0fdfe4c4ad8"
    sha256 cellar: :any,                 arm64_ventura:  "1b27f5277eb2cdfac9f3970ee9adadddc5e04e45469de05a663bc16e793b4eea"
    sha256 cellar: :any,                 arm64_monterey: "41911a73dc6a44c9788c198abc18307213d070d7ca6375e8dd6994335aaee136"
    sha256 cellar: :any,                 sonoma:         "b68d33a5e3c79a0f457d96de1ad1f200c05314f5fea9244d712847c92032b5f7"
    sha256 cellar: :any,                 ventura:        "10b845b1505892ff585b49e89fe3b09761d148b2c14ca6f5a1aa58002452f8f0"
    sha256 cellar: :any,                 monterey:       "449c76665ac72b34daeb1a09dd19217e3be1e723c63ec3ac88e02b8c9a750f34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed490b627b327b3458a70a78c546be07d57bfc6958921f875b76e85f6be51f47"
  end

  head do
    url "https://github.com/jqlang/jq.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "oniguruma"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-maintainer-mode"
    system "make", "install"
  end

  test do
    assert_equal "2\n", pipe_output("#{bin}/jq .bar", '{"foo":1, "bar":2}')
  end
end
