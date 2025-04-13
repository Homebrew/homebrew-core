class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.7.13+release.autotools.tar.gz"
  version "0.7.13"
  sha256 "dcd7cde4f9c498eb496c4556e1c1b81353e2a74747e8270a42565117ea42e1f1"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6b767ef8ae5e15125c2a852db9bec69c57c997c3c151a20368fdcc16197b255f"
    sha256 cellar: :any,                 arm64_sonoma:  "1bb5f077a947f245ffeaf0eb9f4942cd33c3b5569fd1e9b400127f0d0943a0d6"
    sha256 cellar: :any,                 arm64_ventura: "62a4ef42a7ed523d0ae62092fec43cbd55e587b009bf030ffe04a5dee2dc0606"
    sha256 cellar: :any,                 sonoma:        "9fe4c4ccb2ca7eff6f24bbe9eaf963daf681ddb16bd9225c7385539ef6644e53"
    sha256 cellar: :any,                 ventura:       "75e06237d8e5a42527e7d2f33399feb6bcc6dafcaf2f8ac43123d6a915fda6fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2cf870131606dcee1e4dd0fff1ac1fa410921fe708d310139d81934d507c2055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7ed3050c7743f0fed603d3a001463d2e9c039526561b128492032841a83ff8c"
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

  resource "homebrew-mystique.s3m" do
    url "https://api.modarchive.org/downloads.php?moduleid=54144#mystique.s3m"
    sha256 "e9a3a679e1c513e1d661b3093350ae3e35b065530d6ececc0a96e98d3ffffaf4"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          "--without-vorbisfile",
                          *std_configure_args
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
