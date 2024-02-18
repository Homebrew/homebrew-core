class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/24.01/MediaInfo_CLI_24.01_GNU_FromSource.tar.bz2"
  sha256 "45e287dba04add1fe2b11f4c787463dbbe6dc32a64daafa6a15c2a084570c124"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfo.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "1e492f819a48228e9480357110861f365c989931af9caa0d605b2374b8d57d9e"
    sha256 cellar: :any,                 arm64_ventura:  "58d646de4183892842d63525d5f2f680eb88231bda708e4f43c93afdacf7a53c"
    sha256 cellar: :any,                 arm64_monterey: "80058b7f8ae64a416af195ec1cafde0bddb5c28a13a3b49da0968601916f4830"
    sha256 cellar: :any,                 sonoma:         "d9ce91e7214f881b2da8b93a437478f0a20b4d75b9954b3a8d3739412156fdca"
    sha256 cellar: :any,                 ventura:        "9e9cd2b3c43aa4be610e15d045712d48a910ef14a0dc862e6fcf33cc51756a84"
    sha256 cellar: :any,                 monterey:       "d5b39c64ca8bf3cdeaaea5c0909de3119bf6d473f1201abf4d3d20f1cb846f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48e72b69eec2e7a9dad529da47610827184b0bcbfd806d1e73f2e5a3fde0035e"
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
