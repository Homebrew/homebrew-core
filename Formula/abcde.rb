class Abcde < Formula
  desc "Better CD Encoder"
  homepage "https://abcde.einval.com"
  url "https://abcde.einval.com/download/abcde-2.7.2.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/abcde/abcde_2.7.2.orig.tar.gz"
  sha256 "aa39881682ac46eb9fc199d1343b97bc56a322b41a5c57013acda31948bc53dd"
  head "https://git.einval.com/git/abcde.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "624851d14d82da04fca226630ba6b98f25b3c2994d7e19e98f367fb0fa6f23ab" => :sierra
    sha256 "e79abd55580a0a164f0f8d89bba7caa52fa1526fa351c25dbad2f98e05d38fbd" => :el_capitan
    sha256 "caa9b573e291c6541ae94e43ae7a6557831d9e5cfa0facd0dd2bfae79bc36579" => :yosemite
    sha256 "9cc3155d7b417f7562dc9a6c4d3bf80c933f7c6811e4bc7e8576cec2d944f1d1" => :mavericks
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
    system "make", "install", "prefix=#{prefix}", "sysconfdir=#{etc}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/abcde -v")
  end
end
