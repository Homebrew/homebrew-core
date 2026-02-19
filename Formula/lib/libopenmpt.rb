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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "e09315408f5be893af14c0d36d2e3a8d5e5aa9443e97d8acdcae39d9b22c1dd4"
    sha256 cellar: :any,                 arm64_sequoia: "ec71c6ec24216db99b40adaa1e1fb4dfbd1404aececa2647b24cb775de74ec4d"
    sha256 cellar: :any,                 arm64_sonoma:  "4acb4e48c93f334f90546da9925decd431f794e54bcf746966ed024f631474d2"
    sha256 cellar: :any,                 sonoma:        "3eb20b31542271030cbaa404eb33b268b405deac211fcf9f2d4e3e558efdcb7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d878406b38aa781f2f2db18fd061bf3b92a594e2cd179366f1517ad25de49156"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74e45d0330a851a48b800b669fc813b22ed5cb977623be03c13fb82122303a3e"
  end

  depends_on "pkgconf" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"

  on_linux do
    depends_on "pulseaudio"
    depends_on "zlib-ng-compat"
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
