class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/25.09/MediaInfo_CLI_25.09_GNU_FromSource.tar.xz"
  sha256 "530412c6b500418afcb11bc43d25791c2a9f87078ec5e5094add33592ff96f44"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfo.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1fde0e86c98978234f53ccdffd1c7e109ca13cdf1fc008611a2174c0ac402aa3"
    sha256 cellar: :any,                 arm64_sequoia: "6426b44cb136492c6210c1ba4850fc7d28420523c7fd675630be4cdc05d5bd2b"
    sha256 cellar: :any,                 arm64_sonoma:  "debe5a84f99fa842471ad6204a9d1eeaa487466813ae9cbf7570738ecea3a983"
    sha256 cellar: :any,                 sonoma:        "f18dffad486184533005853c224b8036829fc4b35f51123bfc7a73491ee7cbbe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a44c0502f6679267fba9a0184f4ce76c9742877e2246e332e5a19775cf60c6d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1823091423c3f494676221bd37c6593c700ef339b144a18960795e5c1baa0282"
  end

  depends_on "pkgconf" => :build
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
    output = shell_output("#{bin}/mediainfo #{test_fixtures("test.mp3")}")
    assert_match <<~EOS, output
      General
      Complete name                            : #{test_fixtures("test.mp3")}
      Format                                   : MPEG Audio
    EOS

    assert_match version.to_s, shell_output("#{bin}/mediainfo --Version")
  end
end
