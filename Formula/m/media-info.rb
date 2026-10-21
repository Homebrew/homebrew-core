class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/source/mediainfo/26.10/mediainfo_26.10.tar.xz"
  sha256 "82f6bce8e58818509022f0bbcc87fce0c6da21822fb2a2a9573b5e3950d8e5f6"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/MediaArea/MediaInfo.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "a0b6129a593b8083d639f2dffcfeb9ae01d115faff9af8d431f4883070623b8c"
    sha256 cellar: :any, arm64_tahoe:       "d6ab5fddf180d74df12bdc9c7394a474c422798230c6cbf710d5be6680b43c82"
    sha256 cellar: :any, arm64_sequoia:     "dd56f31dfe6e864c8f11e89ab2d17f37120f6517c270d34a5fdd06a6c769dd46"
    sha256 cellar: :any, arm64_linux:       "5e278256bc02cabfeb6ad5139fa2df4a358eb1cfcd61bb713d408d80408ab7f9"
    sha256 cellar: :any, x86_64_linux:      "8e17d00b40e58d0bc6976aa1904d043a341140b700befff7e37e2f5013db1f6d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libmediainfo"
  depends_on "libzen"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    cd "Project/GNU/CLI" do
      system "autoreconf", "--force", "--install", "--verbose"
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
