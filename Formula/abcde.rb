class Abcde < Formula
  desc "Better CD Encoder"
  homepage "https://abcde.einval.com"
  url "https://abcde.einval.com/download/abcde-2.8.1.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/abcde/abcde_2.8.1.orig.tar.gz"
  sha256 "e49c71d7ddcd312dcc819c3be203abd3d09d286500ee777cde434c7881962b39"
  revision 1
  head "https://git.einval.com/git/abcde.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6103b36d2a9d39a8dc303c96f12741ec0f83750688832cf79aa4156a7efae5ce" => :sierra
    sha256 "6103b36d2a9d39a8dc303c96f12741ec0f83750688832cf79aa4156a7efae5ce" => :el_capitan
    sha256 "6103b36d2a9d39a8dc303c96f12741ec0f83750688832cf79aa4156a7efae5ce" => :yosemite
  end

  depends_on "cd-discid"
  depends_on "cdrtools"
  depends_on "id3v2"
  depends_on "mkcue"
  depends_on "flac" => :optional
  depends_on "lame" => :optional
  depends_on "vorbis-tools" => :optional
  depends_on "glyr" => :optional

  def install
    # Fixes MD5SUM being set to nonexistent md5sum
    # Reported upstream 2017-03-18 18:03 GMT
    # https://abcde.einval.com/bugzilla/show_bug.cgi?id=59
    inreplace "abcde", "OSFLAVOUR=OSX", "MD5SUM=md5\n\tOSFLAVOUR=OSX"

    system "make", "install", "prefix=#{prefix}", "sysconfdir=#{etc}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/abcde -v")
  end
end
