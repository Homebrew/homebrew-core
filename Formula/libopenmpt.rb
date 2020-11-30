class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.5.4+release.autotools.tar.gz"
  version "0.5.4"
  sha256 "f34d06b9daa7bca111625369e5bbc2e7c0e0e04737a439b0e6320811babcef40"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    cellar :any
    sha256 "54de329b1d56520a69c206277e059ba40e00975f74541e19002074807c91808c" => :big_sur
    sha256 "c5277617d0a90bc0928861bffa8ded5ec2607c5db240f7b1be58478cf74fc772" => :catalina
    sha256 "ca7ec39beeafbd8e21ed2b5a0076ae4c603b3e55f150ee241a9f12a17a36b080" => :mojave
    sha256 "be35d3a0df76b160ff4fe9bc5ebdd7a2ac462d431bca56f451b3829fdf08ca8c" => :high_sierra
  end

  depends_on "pkg-config" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"

  resource "mystique.s3m" do
    url "https://api.modarchive.org/downloads.php?moduleid=54144#mystique.s3m"
    sha256 "e9a3a679e1c513e1d661b3093350ae3e35b065530d6ececc0a96e98d3ffffaf4"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-vorbisfile"

    system "make"
    system "make", "install"
  end

  test do
    resource("mystique.s3m").stage do
      output = shell_output("#{bin}/openmpt123 --probe mystique.s3m")
      assert_match "Success", output
    end
  end
end
