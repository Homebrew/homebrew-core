class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/24.04/MediaInfo_CLI_24.04_GNU_FromSource.tar.bz2"
  sha256 "05a12f991ac2a275c64f9944d5012548dc768339c677b530b6ee473cc1d501e4"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfo.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c576666c7872ed3dd3b80dbb9fc426c9b4539d2da6cd77eda1203fafb526544d"
    sha256 cellar: :any,                 arm64_ventura:  "5779493321ee2257d547f7ba4e33b1d6ac000efe928f8d5ae054e783432d8f8f"
    sha256 cellar: :any,                 arm64_monterey: "77a7314f37c18109cd6dd240a902165d84dda390360fe172cf95135219a09e4f"
    sha256 cellar: :any,                 sonoma:         "d89e164e84857578f5ee68b5f7adcc2c57a516ce5b1d88483321ad5d38834290"
    sha256 cellar: :any,                 ventura:        "7766623d350b6bb3042c877bf54b3cade4c2063c20022a1c67276ae903ddf866"
    sha256 cellar: :any,                 monterey:       "2df04c6c935e5ad69eddf15ffb495f1a302b7e7f0bc13b1dc50307d46071acbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b1b6a4771ff3be88ac8db186a661ad1ea43966c52d60e56745558110bd9977e"
  end

  depends_on "pkg-config" => :build
  depends_on "libmediainfo"
  depends_on "libzen"

  uses_from_macos "zlib"

  def install
    cd "MediaInfo/Project/GNU/CLI" do
      system "./configure", *std_configure_args
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/mediainfo", test_fixtures("test.mp3"))
  end
end
