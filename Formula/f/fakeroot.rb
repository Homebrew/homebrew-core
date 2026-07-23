class Fakeroot < Formula
  desc "Provide a fake root environment"
  homepage "https://tracker.debian.org/pkg/fakeroot"
  url "https://ftp.debian.org/debian/pool/main/f/fakeroot/fakeroot_2.1.4.orig.tar.xz"
  sha256 "0822bd5a9f0cf19d2ba0546b88b0432d4d3d9917db62c57b74044ccadba06e49"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/f/fakeroot/"
    regex(/href=.*?fakeroot[._-]v?(\d+(?:\.\d+)+)[._-]orig\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fff7162710a0bf52e0046c2409e2be2c718b6aa4f3d92d8872b8bfb8aa84c03c"
    sha256 cellar: :any, arm64_sequoia: "250a594622dff9f0d70faaba52d14ed86a7217834481bdde6c44933a1e728bbd"
    sha256 cellar: :any, arm64_sonoma:  "3d6d3c7bea77e4d57840156baec430b3b4a52915d38be369a6a1aa18b61a05c2"
    sha256 cellar: :any, sonoma:        "83d4fd2e5c4ebb409ea59395e577a9978bcaf9a1ede0c41ff3f6b88846a90e09"
    sha256 cellar: :any, arm64_linux:   "bbca4b36f7d495ca938df2c04976cfcbcd6b3c47376e55f4ecc41daec914807d"
    sha256 cellar: :any, x86_64_linux:  "cce849b081964ed904093aaa338aa71533d97e3cfd78e2c77e040a2f5d4db94d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  on_linux do
    depends_on "libcap" => :build
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"

    args = ["--disable-silent-rules"]
    args << "--disable-static" if OS.mac?

    system "./configure", *args, *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fakeroot -v")
  end
end
