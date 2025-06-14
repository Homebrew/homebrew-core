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
    sha256 cellar: :any,                 arm64_sequoia: "37d13180af54e2ddb20be5e9a93189e06ef099dc441fa6199dd6452e88f0f8f3"
    sha256 cellar: :any,                 arm64_sonoma:  "e7f8a7eebc4dc1e3db14a4e04acd46a50d6791efb0a484fed3cc548313d0db3d"
    sha256 cellar: :any,                 arm64_ventura: "c4360547b56d28351c0f33f10dc830b4706b85363b2fbfca222dc3815431d7e4"
    sha256 cellar: :any,                 sonoma:        "b8f2e7a3694ae395ee177151032b8360e017be99fe1c1e094f7d07e8644e8817"
    sha256 cellar: :any,                 ventura:       "3c9f5d3ddfa9737b56fbf272bd7b52a5933dcaa98494c040a5c70c6d3a48a5d5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb4d2a6336ca02311e52271ddc29cab52fa334d8830629452585e5eae794ec0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "914999916490d887b7bda07dc1f05d6e97d23be0e902cc582b03960ae15a0cbd"
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
