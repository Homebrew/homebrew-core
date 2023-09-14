class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/23.09/MediaInfo_CLI_23.09_GNU_FromSource.tar.bz2"
  sha256 "569c8dc25ecc2c39e2b4ec13ca3d5700db795d6a927d72138cdb3ff22629d1ab"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfo.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8e04fc3bb02ac65bc129ff4cb70a1565d41098198fdf32f58a1d9d32a04fa41b"
    sha256 cellar: :any,                 arm64_monterey: "f2c444b547d3fafc5e1cd0312a1b7e40d3509ac8c5031977dc00b606a596540c"
    sha256 cellar: :any,                 arm64_big_sur:  "f7299972df26b456b15670992624c56fb305e5b835fb1ce8a8f821663c98477f"
    sha256 cellar: :any,                 ventura:        "85c2450fe6c53b38db3f2839d6ad35a57ebcbf91fd31d4f044b693d575666f78"
    sha256 cellar: :any,                 monterey:       "be9f9e2f30961e19661f5a2c572b83edcece290aa0c715963bc17016b62b789d"
    sha256 cellar: :any,                 big_sur:        "2114f858209a73c14e2edb6cce12dbc89b6f3aee233646d97c3ae0c7f6b330b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c2869a098330d3d9b15f73107b6a269d6b5260aa24b7b45e1973455a2285fa0"
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
