class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/25.03/MediaInfo_CLI_25.03_GNU_FromSource.tar.xz"
  sha256 "248f2183f1db14b2d70c5650e5fda84cc9923e1c57a79b9000000f09803e13fa"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfo.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "538c49ef28149aaece910272a03cdeeb7eccbdd15c71568657a07f195ab25743"
    sha256 cellar: :any,                 arm64_sonoma:  "67311beafa0408e299abada45b60a7d84e19229784e5ad9ffa416e56b14466d5"
    sha256 cellar: :any,                 arm64_ventura: "6306b082daf856561e5dc2aa16a0e898583289873e40198193691f638d5b8709"
    sha256 cellar: :any,                 sonoma:        "f628cb2450ea768867931b1a1b076e2606743f435e4ce5cff71949cad32af3ee"
    sha256 cellar: :any,                 ventura:       "433f57fd158ffe0cd7947033711da1f1fa57b92394a4d81ea11a6873e36c1bdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e60d466799e44220678f9e828daf9d83a1b578575993b0c7480e5b0a3c21392b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbb7ca81ee78237872dd466f08bad8ba69e65d3592ab337e97f16a214babe5c8"
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
