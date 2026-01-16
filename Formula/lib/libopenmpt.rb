class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.8.4+release.autotools.tar.gz"
  version "0.8.4"
  sha256 "627f9bf11aacae615a1f2c982c7e88cb21f11b2d6f0267946f7c82c5eae4943b"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4be673aceb001642e12d2f7992946bf85305a42561227daba2b0389d4442f46d"
    sha256 cellar: :any,                 arm64_sequoia: "684c17f93ecbc379409f75d3f275c7998cbd95fff7b7aa4c59700f03014b9be7"
    sha256 cellar: :any,                 arm64_sonoma:  "291cc2513e0a63db6f3d11f186701c08f291b23fe1839b1c1afe5afe819e27c4"
    sha256 cellar: :any,                 sonoma:        "486cf7ec136a7cc464593c7eb5e887cbc9852ba402c0d6258287f43801c3d663"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "690df6cd7e7e7af1ff89eb1160180f0c54fdaa0457b9e43409efe52556fb4f6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4febab73735e3851d7e10a3f88815915856ea329a8a4427d625dc82c28e2f39"
  end

  depends_on "pkgconf" => :build

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

  def install
    system "./configure", "--disable-silent-rules",
                          "--without-vorbisfile",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    resource "homebrew-mystique.s3m" do
      url "https://api.modarchive.org/downloads.php?moduleid=54144#mystique.s3m"
      sha256 "e9a3a679e1c513e1d661b3093350ae3e35b065530d6ececc0a96e98d3ffffaf4"
    end

    resource("homebrew-mystique.s3m").stage do
      output = shell_output("#{bin}/openmpt123 --probe mystique.s3m")
      assert_match "Success", output
    end
  end
end
