class Abcde < Formula
  desc "Better CD Encoder"
  homepage "https://abcde.einval.com"
  url "https://abcde.einval.com/download/abcde-2.9.1.tar.gz"
  sha256 "70ec6e06b791115fbe88dee313f58f691f9b559ee992f2af5ed64fe6ad2e55d7"
  head "https://git.einval.com/git/abcde.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbe18dcaf13aac68e57b10523c146d62b757e520103a7e3a009d317851ee80ad" => :high_sierra
    sha256 "bbe18dcaf13aac68e57b10523c146d62b757e520103a7e3a009d317851ee80ad" => :sierra
    sha256 "bbe18dcaf13aac68e57b10523c146d62b757e520103a7e3a009d317851ee80ad" => :el_capitan
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
