class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.5.6+release.autotools.tar.gz"
  version "0.5.6"
  sha256 "17dea782b334c146f4acd948c7c31ffdd2afc899eb347ebe01be1606ea79f4b8"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "fd051718667d70e0a3bbf022767a9f7206f2d728143a99a4cf00ec9f732590f9"
    sha256 cellar: :any, big_sur:       "32ec9749dee285ad9dc2028e159289f03a734aa458d44e04f80a2ea88e2cdf14"
    sha256 cellar: :any, catalina:      "b0e7403f3fa51099be0e74a51bd1f419041d8cddd5cbf7f875db03cb2771d9b2"
    sha256 cellar: :any, mojave:        "8826e1e7cffa4ef09fb9c680dca07e974b4508ee9094c4ae80ca98639965c6c3"
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
    depends_on "gcc" # for C++17
    depends_on "pulseaudio"
  end

  fails_with gcc: "5"

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
