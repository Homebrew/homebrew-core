class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.8.1+release.autotools.tar.gz"
  version "0.8.1"
  sha256 "5ccc291e4457925f3ca3e8144f5b645c4a3dcc2bc05dc9a39651132b32b83bce"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "af3b10e8707f87ff9b9ba39f1b1355dd08953d9ff68faa352ce4f7e3d2ef6d81"
    sha256 cellar: :any,                 arm64_sonoma:  "c392eb043cdd93821d177096d604ac4eddbe74fc49b4579a8ba05d5ffe1a7419"
    sha256 cellar: :any,                 arm64_ventura: "41b31c3435eca9e992b84019752ec3f09f2e38d8fd5d7a1780d85f7f292f0f64"
    sha256 cellar: :any,                 sonoma:        "5273f9e14b610eb4ab5b7099b831ba7e59b76c659aef5829b09a4fc24b85b62c"
    sha256 cellar: :any,                 ventura:       "a4050cd448ab8671ddf95077beaabd0fe5e560899239e0061d42237079d55613"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65c297e0d0a5e4a53a681480087c14a90779cd8ac94074550666db6eb50825ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0c485f965853e9c5c8e6babe16e591610bbdc716c27f8c0299a09de01d8566e"
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
