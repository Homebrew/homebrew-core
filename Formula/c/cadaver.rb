class Cadaver < Formula
  desc "Command-line client for DAV"
  homepage "https://notroj.github.io/cadaver/"
  url "https://notroj.github.io/cadaver/cadaver-0.26.tar.gz"
  sha256 "9236e43cdf3505d9ef06185fda43252840105c0c02d9370b6e1077d866357b55"
  license "GPL-2.0-only"

  livecheck do
    url :homepage
    regex(/href=.*?cadaver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_sequoia: "1865f65bd09a67eab16c71888453b96c58b83d5ee053cb8b0afaf9ce632b3149"
    sha256 arm64_sonoma:  "2da179616e40cf56092cde66d44281e7f7f1031507642299f13702031f650d31"
    sha256 arm64_ventura: "dbfd46990bd7f0da5555531fe05b453ed720ef200c000d4e72bcb2e6a0acd506"
    sha256 sonoma:        "abfa76ac943d4031ba46c0147e83dbb13cdc6f5049d1c66eba7396572e0bc437"
    sha256 ventura:       "a5369a2c7d4c1b21b64035be3c3a899872fb7e55c10374343386aee3a82d6fa6"
    sha256 arm64_linux:   "279521b28588a76695e693ce6397e2641d117a9b217a2c06337501f599fd430e"
    sha256 x86_64_linux:  "aca16f2c07fb756b65f35d3b6ed8f53f7f07226bb7657a6ec009629eb014732b"
  end

  head do
    url "https://github.com/notroj/cadaver.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "neon"
  depends_on "openssl@3"
  depends_on "readline"

  on_macos do
    depends_on "gettext"
  end

  def install
    if build.head?
      ENV["LIBTOOLIZE"] = "glibtoolize"
      system "./autogen.sh"
    end
    system "./configure", "--with-ssl=openssl",
                          "--with-libs=#{Formula["openssl@3"].opt_prefix}",
                          "--with-neon=#{Formula["neon"].opt_prefix}",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_match "cadaver #{version}", shell_output("#{bin}/cadaver -V", 255)
  end
end
