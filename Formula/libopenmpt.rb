class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.6.8+release.autotools.tar.gz"
  version "0.6.8"
  sha256 "1c618b3dff1a7cb6a24f431755920fa243756268138ffa31d3db7c607c2c2d69"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d86d4d9035dd7d841e28cbf0440fd6f4870ae8ccb2b9959bf6e65ae76079166e"
    sha256 cellar: :any,                 arm64_monterey: "af23ef86afe4ab8c1349f458d9c81b69e91e1e84fe1b063aa3d1124cac9f97a6"
    sha256 cellar: :any,                 arm64_big_sur:  "6cab66f1fe661c02ca369ab208b8a5feaf5bb2b22fff105a25098f5ef2a71b3b"
    sha256 cellar: :any,                 ventura:        "d39af97b0e6acc83fb2f88b6c895bd08d2b1522f712fa9991e08d9b16eaf6194"
    sha256 cellar: :any,                 monterey:       "cf958410dc4a8c683c9e7ffa53fa3b9a7cdd6ad1db99a1a1332d02200c699411"
    sha256 cellar: :any,                 big_sur:        "d1251bab7029da431d5eecb3812898ace9cc83b9b386b4aaeaeb4e26cbfc9071"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc339310ff0416fb3f21190c74898992c6859b96a2a9639abf8d9b6d54d567f2"
  end

  depends_on "pkg-config" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pulseaudio"
  end

  fails_with gcc: "5" # needs C++17

  resource "homebrew-mystique.s3m" do
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
    resource("homebrew-mystique.s3m").stage do
      output = shell_output("#{bin}/openmpt123 --probe mystique.s3m")
      assert_match "Success", output
    end
  end
end
