class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.8.5+release.autotools.tar.gz"
  version "0.8.5"
  sha256 "f680aeabb3f84c37169dad87f15ed83f29a6ebbc7f689f912d4dabecff0e3324"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9410dce2e9d53fec0308532e4f130f45da41049c838d4e8dd85d389862e393b3"
    sha256 cellar: :any,                 arm64_sequoia: "7eb7be2b5946cbf99b34029aef1ea63dcbb7cd99a539faa77aaa80d2a5418e12"
    sha256 cellar: :any,                 arm64_sonoma:  "66d6f0ea61c7b97b15db645a367629563455c90b8ec02ce7334e4b4ac5ac6c90"
    sha256 cellar: :any,                 sonoma:        "91ab2d929bd796f4081e45c5134a3abd311d93731bc635e43ccb4ecdac5220cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e037348b0c8461c848a5cc4844e8d811f744d5b5bd5fd9769df7182ec115e538"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "893880e2acd14accfeca74561c556e58449cf99344643c3e9cf6a0c4c9061f03"
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
