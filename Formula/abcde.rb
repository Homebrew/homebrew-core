class Abcde < Formula
  desc "Better CD Encoder"
  homepage "https://abcde.einval.com"
  url "https://abcde.einval.com/download/abcde-2.9.2.tar.gz"
  sha256 "34356c6ea4cc39b33c807261bfdf8e8da8905b2ed50313147c78b283eef6858d"
  head "https://git.einval.com/git/abcde.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b7ee1b87d6c028ce17940bb59890f2f6e3d256310a06b8dc21bf35d07bf650b" => :high_sierra
    sha256 "6b7ee1b87d6c028ce17940bb59890f2f6e3d256310a06b8dc21bf35d07bf650b" => :sierra
    sha256 "6b7ee1b87d6c028ce17940bb59890f2f6e3d256310a06b8dc21bf35d07bf650b" => :el_capitan
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
