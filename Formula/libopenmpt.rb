class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.6.4+release.autotools.tar.gz"
  version "0.6.4"
  sha256 "e09fb845c3292700a7ac13c3b31d669ecd3bdbebcbfe1328eba2376cebe40162"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0eb53cb23e34cc2d7116342b8f50aa2481447998949bc8ed22a67d04d4f4f717"
    sha256 cellar: :any,                 arm64_big_sur:  "edadba2b2195b66b53d764249527ef5294badaf175c678ed58711153ea9cfdd9"
    sha256 cellar: :any,                 monterey:       "20205d6a2c015ea5a92504f721780f17a959a9f5e7103fff9bd36b6155715b76"
    sha256 cellar: :any,                 big_sur:        "cff4b53361e26c0c7b32c14017d305bb00cdb356a65c53d180c092fdadc85e3c"
    sha256 cellar: :any,                 catalina:       "43d3a996c15055afcc0fe14628cd472219d42997641acb77dc45b8d4343ba73d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27aec280ef3ff37b23a2a3e5c6c82a05f808da9af2067ee722ec8cb72cfbbe21"
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
    depends_on "gcc"
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
