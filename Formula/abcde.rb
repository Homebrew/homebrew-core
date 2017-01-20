class Abcde < Formula
  desc "Better CD Encoder"
  homepage "https://abcde.einval.com"
  url "https://abcde.einval.com/download/abcde-2.8.1.tar.gz"
  sha256 "e49c71d7ddcd312dcc819c3be203abd3d09d286500ee777cde434c7881962b39"
  head "https://git.einval.com/git/abcde.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fac3e946bd08c5ed0ddf06dc6fd4aef2ba558060728fb0b14d7d462f52661e06" => :sierra
    sha256 "55f693801ec277caf7268c62253f87bcf8b2b25a10f873c3a37c0b50aba3056f" => :el_capitan
    sha256 "55f693801ec277caf7268c62253f87bcf8b2b25a10f873c3a37c0b50aba3056f" => :yosemite
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
