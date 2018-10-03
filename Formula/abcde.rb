class Abcde < Formula
  desc "Better CD Encoder"
  homepage "https://abcde.einval.com"
  url "https://abcde.einval.com/download/abcde-2.9.2.tar.gz"
  sha256 "34356c6ea4cc39b33c807261bfdf8e8da8905b2ed50313147c78b283eef6858d"
  revision 1
  head "https://git.einval.com/git/abcde.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b390aaedef649f141a790b7291db5db37e288a28a11962b30799769cc8fe979" => :mojave
    sha256 "d24c74859027cb359cd0b1eb3966551da4641dd44ea001c33b45e596ccc7b9bb" => :high_sierra
    sha256 "d24c74859027cb359cd0b1eb3966551da4641dd44ea001c33b45e596ccc7b9bb" => :sierra
  end

  depends_on "cd-discid"
  depends_on "cdrtools"
  depends_on "flac"
  depends_on "glyr"
  depends_on "id3v2"
  depends_on "lame"
  depends_on "mkcue"
  depends_on "vorbis-tools"

  def install
    system "make", "install", "prefix=#{prefix}", "sysconfdir=#{etc}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/abcde -v")
  end
end
