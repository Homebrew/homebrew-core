class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.7.3+release.autotools.tar.gz"
  version "0.7.3"
  sha256 "2cf8369b7916b09264f3f14b9fb6cef35a6e9bee0328dec4f49d98211ccfd722"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0a979e78d903b146e46d32dfc08a27d6b8669dbd2548e27bbbb8274fd266f802"
    sha256 cellar: :any,                 arm64_ventura:  "5f65eb84aae8173b6d8bef713c3331a9506f4755c7603125905ae7a9a82b18a0"
    sha256 cellar: :any,                 arm64_monterey: "761cbc95caaacd0aa93a58cb235c8eee5422b736a900909e0c37823c994acd0c"
    sha256 cellar: :any,                 arm64_big_sur:  "42588b9b1091d23b77a8a12f3e7780fcd2adf76366ffa9ebdf56bfb465ab415a"
    sha256 cellar: :any,                 sonoma:         "50d08af84a5355c914a6026df69491274f2ad7539ef847ae26860cabf244f0e5"
    sha256 cellar: :any,                 ventura:        "0d26b0d7e64c33bbbe1983774c46467fa62bb34280b661ed4beac439203e816f"
    sha256 cellar: :any,                 monterey:       "5cc22ed4759b9293444cbdffe54e4ea06e15d42f7819d652c852856485dfd09d"
    sha256 cellar: :any,                 big_sur:        "58a2ab4fa7e32541621d6c84af7392d8db0becd031cc4a9aae52482eabd28783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc210af07f400ae65425718c3df0b0b61933afa3b40b90cf730fa68345b760f2"
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
