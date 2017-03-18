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
    sha256 "53a4212fb0aedcc304f88c972935c365a1547fd59c3d942dd2bcea0dfd0e7bbf" => :sierra
    sha256 "2021393f54fbe42f4c94d303d124c487d8c0aec6bc1d6a2fa8c1368d38be3735" => :el_capitan
    sha256 "2021393f54fbe42f4c94d303d124c487d8c0aec6bc1d6a2fa8c1368d38be3735" => :yosemite
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
