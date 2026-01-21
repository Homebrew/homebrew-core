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
    rebuild 1
    sha256 arm64_tahoe:   "71e27509f2f5051c193c6dde207ea520cbd24d1f3d7a90664cd67befce73adb1"
    sha256 arm64_sequoia: "093990114c593106e24cfd2e289dab0972431ad116963e132ced44a8e89b7bd2"
    sha256 arm64_sonoma:  "3ca9671420bb9e1e7ad7c7364afc53d20d1dc663332ad74205743dfb35b5191c"
    sha256 sonoma:        "9bb8fa8d9d96fb01773c04fa564c8b4103c82fbd9e686198dc02944b09b2dbbc"
    sha256 arm64_linux:   "999824bf55c08a531c0eb124f5fc53f9b9b7b66287cec4243a3ce5c2445f522a"
    sha256 x86_64_linux:  "b2b5ae6925094b4619cc97902c8bdd27088fbbd78343f5acc4d9fe2b6153d58d"
  end

  depends_on "pkgconf" => :build
  depends_on "flac"
  depends_on "libid3tag"
  depends_on "libogg"
  depends_on "libtool"
  depends_on "libvorbis"
  depends_on "mad"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Disabling usage of EOL `pcre`. Can be reconsidered if upstream ports to `pcre2`.
    # Issue ref: https://github.com/mp3splt/mp3splt/issues/366
    system "./configure", "--disable-pcre", *std_configure_args
    system "make", "install"
  end
end
