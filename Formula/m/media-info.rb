class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/24.05/MediaInfo_CLI_24.05_GNU_FromSource.tar.bz2"
  sha256 "b208a1c975caed95b66af81174cc74c304efe9a63ce68a47e006efe8d87cd1e3"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfo.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bb4bab725f475a851cb14024d57c766b6bf0ed8486724100c0810ca9ac2fa2d2"
    sha256 cellar: :any,                 arm64_ventura:  "8c2870e425a392f6bdfd7d6ecf037d6229e44c99d5d2522305d2b4f53e44f6d7"
    sha256 cellar: :any,                 arm64_monterey: "d3dc1e87bbfd9cf0a3d512163233091fb39b5c763047bbe97d8c366253d3a17e"
    sha256 cellar: :any,                 sonoma:         "d6cbf3037d1b79ac9ab10197d5e97296f30f54b8c254a1323f789d58600a39f8"
    sha256 cellar: :any,                 ventura:        "519a780fe8400da4b29b58301465c9e11643020729ff90629aa455172322c1c3"
    sha256 cellar: :any,                 monterey:       "8f947b8cca407c8cbd77318560f67b3a8a829c2a07dd6f45d49dbede96b7f3a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1949a9daa327ae5bbfd7991602cefadb65d4d5b5a3d6b264e0fcf49d7edec7c5"
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
