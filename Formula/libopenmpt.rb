class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.5.14+release.autotools.tar.gz"
  version "0.5.14"
  sha256 "a979c1a763dcb420d40004eaeadd5532153b63493e6bfb71362204ee8a75abdc"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2dbc0fb830ca2c2ff1b10a6b2c9751a1f08618fb4edbaa1e137b6ee1b419f809"
    sha256 cellar: :any,                 arm64_big_sur:  "efd81612b412e72eae57f5bdace6ddffb48cb3fb52a60a0712b470c39ace7fc7"
    sha256 cellar: :any,                 monterey:       "6cb927161b27467d6f285ad19f964e57337ec16c43906f183410b34c46415fe0"
    sha256 cellar: :any,                 big_sur:        "260b60c163b98d46477c9e4f66b3051ac603d96ebe69eea0187d3dc9002efcda"
    sha256 cellar: :any,                 catalina:       "b3d93f4dd628bc8fc0c0e592c1b99293bf350c565d820d912119a0bfad12bc82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49a4cb8f11cc744237c6ae7f86f8616b2a61bf2b68f0aa679b781411da7443d9"
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
