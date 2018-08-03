class Abcde < Formula
  desc "Better CD Encoder"
  homepage "https://abcde.einval.com"
  url "https://abcde.einval.com/download/abcde-2.9.2.tar.gz"
  sha256 "34356c6ea4cc39b33c807261bfdf8e8da8905b2ed50313147c78b283eef6858d"
  head "https://git.einval.com/git/abcde.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "53f3003b0da0bfb56ef0919818a35345f5499dc6339ccdc85a90bb149e7f32ce" => :high_sierra
    sha256 "53f3003b0da0bfb56ef0919818a35345f5499dc6339ccdc85a90bb149e7f32ce" => :sierra
    sha256 "53f3003b0da0bfb56ef0919818a35345f5499dc6339ccdc85a90bb149e7f32ce" => :el_capitan
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
