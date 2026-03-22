class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.8.4+release.autotools.tar.gz"
  version "0.8.4"
  sha256 "627f9bf11aacae615a1f2c982c7e88cb21f11b2d6f0267946f7c82c5eae4943b"
  license "BSD-3-Clause"
  revision 1
  compatibility_version 1

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "90eb85d01cb0b35f70fc70888edde939013c407f859a36b9f5716005d4c6f0f9"
    sha256 cellar: :any,                 arm64_sequoia: "4cd9991a4e1e79edf673ba45fbf3bba240dd24988a933a0d93dd960d76374a84"
    sha256 cellar: :any,                 arm64_sonoma:  "20c555a5bb1e0683a8961a0c3dac5661f9ec3852d2998ed45b81205a3466172e"
    sha256 cellar: :any,                 sonoma:        "347c430a3d323e1df2aac0fbf23c35fb8b39b8ab74c41fd150d1c6b409147377"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c512c665eabc47c68eb9d855d401b549bee65be4594980c7e6a5680f3d571b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfc09063e376c43530eac84aabd7ddc04e06f1c1945ce2ca6544742862f60da0"
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
