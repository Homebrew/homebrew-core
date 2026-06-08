class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/source/mediainfo/26.05/mediainfo_26.05.tar.xz"
  sha256 "f852093f9050022d699606eeabb38b24da5523d0212fab64dc4e4d3e46b56de1"
  license "BSD-2-Clause"
  compatibility_version 1
  head "https://github.com/MediaArea/MediaInfo.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6c8ff8a05ce2a9f56486abbe3d6a80e6b28e89223a771b11255b124a2fbc59cd"
    sha256 cellar: :any,                 arm64_sequoia: "7fbe894ef603992a1fa932028573cc719bb34ae95e150a98b663a80bcf1fc809"
    sha256 cellar: :any,                 arm64_sonoma:  "83c63a7dd5bc9bf71886b1e6871ef7120e391ad1ab40a1b806616e0d7a15d8ca"
    sha256 cellar: :any,                 sonoma:        "d378495c8e13c2699edf453a6abdbb026959b251c0b9b2832a9bd985c300492b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd5c791bf94ff44f3947837551a802b978781bba9d4859bb121443bbe8f2faf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a052945b587b0264c9598037935b714b4ee8704fb2149e465b328d17b5aed40"
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
