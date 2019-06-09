class Mtn < Formula
  desc "Saves thumbnails (screenshots) of movie or video files to jpeg files"
  homepage "https://gitlab.com/movie_thumbnailer/mtn/wikis/home"
  url "https://gitlab.com/movie_thumbnailer/mtn/-/archive/3.3.2/mtn-3.3.2.tar.gz"
  sha256 "471ec0172a1753d684032edb8296ef01af115538619daa417678ac037328daf5"

  depends_on "ffmpeg"
  depends_on "gd"

  def install
    system "make", "-Csrc", "install", "PREFIX=#{prefix}"
  end

  test do
    system "curl", "--output", "sample.avi", "-L", "https://bitbucket.org/wahibre/mtn/downloads/sample.avi"
    system "echo '918243383bc9a3a8ff37da451f4b6b17f9636769  sample_s.jpg' > checksum"
    system "#{bin}/mtn", "sample.avi"
    system "shasum", "--check", "checksum"
  end
end
