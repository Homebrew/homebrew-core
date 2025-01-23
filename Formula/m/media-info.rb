class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/24.12/MediaInfo_CLI_24.12_GNU_FromSource.tar.bz2"
  sha256 "5f7648080287d3e8f80dd8d606e285af81aa6a40dff1936fd528cbb74a0d97ff"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfo.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "526cee110889dac29d75fa89fa04cffdd0ed3d6ee086142b49074da094a68358"
    sha256 cellar: :any,                 arm64_sonoma:  "9d377748efc4f79ca0f0422c3ef821692b0dd80ec69c18ed5243dde4ec557ee3"
    sha256 cellar: :any,                 arm64_ventura: "c00c1c687b54182cc44e1c4673ab88afe6a9a60b229df4713d11454cc48ab3fc"
    sha256 cellar: :any,                 sonoma:        "c19eaff225939b0865017a75384065f7df599110cadd07d1fcbf43c06fd3f768"
    sha256 cellar: :any,                 ventura:       "db263df9ab51d08c8521410dad7d52fd205afb00d0129850cb3dc5ece33d376a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5acee3bccbe8ca89c545db210985301c1dbbc81f15dd1023cfd7bdb3110ad104"
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
