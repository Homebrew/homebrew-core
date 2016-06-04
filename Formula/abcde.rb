class Abcde < Formula
  desc "Better CD Encoder"
  homepage "https://abcde.einval.com"
  url "https://abcde.einval.com/download/abcde-2.7.2.tar.gz"
  mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/a/abcde/abcde_2.7.2.orig.tar.gz"
  sha256 "aa39881682ac46eb9fc199d1343b97bc56a322b41a5c57013acda31948bc53dd"
  head "https://git.einval.com/git/abcde.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "91bebd8a7c17518bfc99f2b8067234024fe012205f2d5d0e193eb64dd2882fc5" => :el_capitan
    sha256 "f553e4ef30cdc2a3a7f01f4874d98cc3fbcb5fb4dabd2ee36496ad7fff2cec89" => :yosemite
    sha256 "754737e1e8adaa267e77f1cec57e414e9e7d4598fe24f3428cc4ad07d280994b" => :mavericks
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
