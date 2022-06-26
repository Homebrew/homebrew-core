class Axel < Formula
  desc "Light UNIX download accelerator"
  homepage "https://github.com/axel-download-accelerator/axel"
  url "https://github.com/axel-download-accelerator/axel/releases/download/v2.17.11/axel-2.17.11.tar.xz"
  sha256 "580b2c18692482fd7f1e2b2819159484311ffc50f6d18924dceb80fd41d4ccf9"
  license "GPL-2.0-or-later"
  head "https://github.com/axel-download-accelerator/axel.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "483732a5fda41e8592d78ce2d4df86362e60f61bbeb41081beaf382f211edea3"
    sha256 cellar: :any, arm64_big_sur:  "8eeafff7031764fcc18d94121c6889a7bc3224ecf3f20225ef5cd96f09c6bfb3"
    sha256 cellar: :any, monterey:       "c5e9ea169ba1985bb10ce39e1c11237bbe4d2c9a1f14b62f38756dcb87456cb9"
    sha256 cellar: :any, big_sur:        "7ce859bfaebd9429851f7b8fcdaf8983c542c91bbcaec2e2d789e8c0e496306f"
    sha256 cellar: :any, catalina:       "a9938c2a4753dcc84631739c7ddba105933ab110995b296c7e4a6da2bd9207fc"
    sha256               x86_64_linux:   "145f3f4fec5782251254a8dd1adbd989118d1be0fe3d4808dce962a586f68119"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}"
    system "make", "install"
  end

  test do
    filename = (testpath/"axel.tar.gz")
    system bin/"axel", "-o", "axel.tar.gz", stable.url
    filename.verify_checksum stable.checksum
    assert_predicate testpath/"axel.tar.gz", :exist?
  end
end
