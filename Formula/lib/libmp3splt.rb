class Libmp3splt < Formula
  desc "Utility library to split mp3, ogg, and FLAC files"
  homepage "https://mp3splt.sourceforge.net/mp3splt_page/home.php"
  url "https://downloads.sourceforge.net/project/mp3splt/libmp3splt/0.9.2/libmp3splt-0.9.2.tar.gz"
  sha256 "30eed64fce58cb379b7cc6a0d8e545579cb99d0f0f31eb00b9acc8aaa1b035dc"
  license "GPL-2.0-only"
  revision 7

  # We check the "libmp3splt" directory page since versions aren't present in
  # the RSS feed as of writing.
  livecheck do
    url "https://sourceforge.net/projects/mp3splt/files/libmp3splt/"
    regex(%r{href=.*?/v?(\d+(?:\.\d+)+[a-z]?)/?["' >]}i)
    strategy :page_match
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "cf832d5f19a4a5c00e9ceccc25a6669791ce4dc1bf2c93b34556ee0eeaa272bf"
    sha256 arm64_sequoia: "7ab04ee463178da4c4319a3e795ad0f18d09aff98450a5f8eacdf206fdb059ff"
    sha256 arm64_sonoma:  "8ac44f180edcd601f4fd078a49742f91387466489c3336d534772702ca8d3e61"
    sha256 arm64_ventura: "2d729d944e28d5d3c651b5be9e7b4aed770fdd51894175b82318414d12fd1850"
    sha256 sonoma:        "b5f348f71b30146bc33730f43b14e5129cb27aa4c9a1bfb6a39c92ac2bbf5ca5"
    sha256 ventura:       "dbacb2e3b18de32c6398f7123f0eb826ad56f1969ac45b027cfd3030544fe8a8"
    sha256 arm64_linux:   "958fa980c431ae3b8c2dc65956c24bf0c0baef98ac9a7cc4b2cd771a8336c5dd"
    sha256 x86_64_linux:  "b92f917113de228d2bac95e4672b4741c8a5256f55834b6b498bc0697e5e4a3c"
  end

  depends_on "pkgconf" => :build
  depends_on "flac"
  depends_on "gettext"
  depends_on "libid3tag"
  depends_on "libogg"
  depends_on "libtool"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "pcre"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end
end
