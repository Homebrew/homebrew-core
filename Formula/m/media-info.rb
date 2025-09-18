class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/25.07/MediaInfo_CLI_25.07_GNU_FromSource.tar.xz"
  sha256 "d810a56b84a8f6c009958312459e1d7353b3722db8f18c2bc87da512ebd51482"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfo.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "347ec93f2297450ff905863812b107d0ad1f631d0d8a547e23fd7670cb7540ef"
    sha256 cellar: :any,                 arm64_sequoia: "2a7f41d3c3f534c273dc79a0983ee30e01acebbd86331837030dbab641269130"
    sha256 cellar: :any,                 arm64_sonoma:  "4f09c007fab3aba0c0862c2a10f93e3b36d1af8b2d47cd323d8d9b02e356ec59"
    sha256 cellar: :any,                 arm64_ventura: "577eca29681abdc343d85bac2c4ccf8e99dda4c2d95e49eb0ff13b2aa73beb65"
    sha256 cellar: :any,                 sonoma:        "f66eff8e3999a7da57b8a70270cb1a330ab9f30451bdb093a592e85cae95fa69"
    sha256 cellar: :any,                 ventura:       "185782a3449f4b8192091dfb4c6f53523eaa998f40fa746435c5eceebff945f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f95ac55e58e4e262f301b99882aabc2aa494c662c8ef5458240c0bd39c5bd82d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71f8a5e4c2dd42bf62fde4d09494995feb0a7cd8dd830c4f7d2621e1d9615dd2"
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
