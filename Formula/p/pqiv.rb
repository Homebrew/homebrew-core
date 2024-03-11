class Pqiv < Formula
  desc "Powerful image viewer with minimal UI"
  homepage "https://github.com/phillipberndt/pqiv"
  url "https://github.com/phillipberndt/pqiv/archive/refs/tags/2.13.1.tar.gz"
  sha256 "1db8567f75884dfc5dd41208f309b11e4e4ca48ecad537915885b64aa03857a4"
  license "GPL-3.0-or-later"
  head "https://github.com/phillipberndt/pqiv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e6f3087028f4d04ca7347ebb3148ce7929c4a57800ff39fe68551cfa63ad9203"
    sha256 cellar: :any,                 arm64_ventura:  "53e710b8e390c8c337300c6e19a4bd733cf633f338b109c00660d09e12c99c9a"
    sha256 cellar: :any,                 arm64_monterey: "3ae1a16b54299b2dd3da5a4acf2d6281ebedff149b10465f5c740fe7701498a6"
    sha256 cellar: :any,                 sonoma:         "bad2754af3a373e363387c9d191729f5a355c63a483d3265656a335098b40980"
    sha256 cellar: :any,                 ventura:        "5fad3776b05dbb2efd7fb21bbb79259da1c3a54b994e7a3dcbc5525769167faf"
    sha256 cellar: :any,                 monterey:       "fe3a78c6d3cbe81e5ed5914dcfba29048cab230373a617e07b4ab9c71697e91c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "768372bfe3a90bed0b57dd04f48e018c0fca37207519fd103b520deb0accf4e5"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+3"
  depends_on "imagemagick"
  depends_on "libarchive"
  depends_on "libspectre"
  depends_on "poppler"
  depends_on "webp"

  on_linux do
    depends_on "libtiff"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pqiv --version 2>&1")
  end
end
