class Minidjvu < Formula
  desc "DjVu multipage encoder, single page encoder/decoder"
  homepage "https://minidjvu.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/minidjvu/minidjvu/0.8/minidjvu-0.8.tar.gz"
  sha256 "e9c892e0272ee4e560eaa2dbd16b40719b9797a1fa2749efeb6622f388dfb74a"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/minidjvu[._-]v?((?!0\.33)\d+(?:\.\d+)+)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "4efc0167c66e2dcc3d940290a93f1c263d2b2f0f77aa2be56a46b698a72fc998"
    sha256 cellar: :any,                 arm64_sequoia:  "a7e2ca4daf17bffbee72e2513829e5835d4d271e9daa28c5c62e806ca05ca6d1"
    sha256 cellar: :any,                 arm64_sonoma:   "affa202294a94626e2135bc65c2e2aacc5e3e5bfba4dc37f9c968d21c917cf09"
    sha256 cellar: :any,                 arm64_ventura:  "2d49c0d30645a4fced0469d6a8e01e0e2e01a2df825a294f8c1f2f96c2e1a88c"
    sha256 cellar: :any,                 arm64_monterey: "99e77ef6ad2913838bb979ef9e675e1f1ca194713cf7e8faf5f1b807e84b927c"
    sha256 cellar: :any,                 arm64_big_sur:  "8b120c1eda7fdb21104835b968eeebcd83f12d36d3bee874d6d42f10f4bbc5c1"
    sha256 cellar: :any,                 sonoma:         "44991a7f8c62e2020d8d37e9d3ee1e2f1637bdeda9e8f7a4c21762a52c4956bc"
    sha256 cellar: :any,                 ventura:        "4ebde838536ddeb8879a44fedea358296ede38ec2ca9d6d43ff10aeade2df579"
    sha256 cellar: :any,                 monterey:       "af61231d4d560cd5476697ea6ef186adaa388569d5cb73d9c03dcec659746c92"
    sha256 cellar: :any,                 big_sur:        "7cefcca081ea49ddddc9bd0731dc0eb2246921720cc7b9ed9a1d2e3e62086aa8"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d5f55dab0d6f87ddc0433308b582a901da2ab14244213b7392afd081f4ffde5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ec855a0237182522d9598ea0afa9e42bb1b008c5a5233d79bb5630e2cf86802"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "djvulibre"
  depends_on "libtiff"

  on_linux do
    depends_on "gzip"
  end

  def install
    inreplace "Makefile.in", "/usr/bin/gzip", Formula["gzip"].opt_bin/"gzip" unless OS.mac?

    ENV.deparallelize
    # force detection of BSD mkdir (macos)
    # outdated configure scripts fail to detect the correct build type (linux arm)
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
    lib.install Dir[prefix/shared_library("*")]
  end
end
