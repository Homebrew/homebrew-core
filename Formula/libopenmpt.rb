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
    sha256 cellar: :any,                 arm64_monterey: "ae0ff7a657ec01c58021a43af5b329c475f0aca41a3fbd7732a9f796321a85b8"
    sha256 cellar: :any,                 arm64_big_sur:  "87abd6b76d93a0ba472036c8c1f28635ea3d24b7976ca6a9920cfb2011167dfa"
    sha256 cellar: :any,                 monterey:       "4838e76c64ca27cdf6cdc81ca9e9a5250605f2dfe7bd79a027e985429462a6d6"
    sha256 cellar: :any,                 big_sur:        "793c68af688bf11d6d9fd8657cdcc8ac91da8023112187b6e83a271c78c91dc4"
    sha256 cellar: :any,                 catalina:       "8eae0f6145e36a73818c516a9ed0099428e467057f3224623b03df47b9c759d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "446de3b35d25cf8a71bcac2b8466c1ad96f9a41c5b641e2b1921e7ceb6337e5b"
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
