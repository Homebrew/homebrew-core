class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.8.9+release.autotools.tar.gz"
  version "0.8.9"
  sha256 "d7ce84fd05d686c4bcf66af40eae857afa371442db60eeda3f874bd6cf6fc318"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7fa95901574c63a2e4863d37577db90f1caa20fd23268bb60a304146152007a7"
    sha256 cellar: :any, arm64_sequoia: "b35d010368d620a701419a6f3a3c668c8e6c5d937ae8a683652610b5a75e318c"
    sha256 cellar: :any, arm64_sonoma:  "628cf4d4ececb7dbb49d5a99f39661a7c2a5a00899dff8470d982cabe65c468e"
    sha256 cellar: :any, sonoma:        "977b0cbf8014f9e371f96272342a004a1358352e2aaed547f18959bbd1a7b4cc"
    sha256 cellar: :any, arm64_linux:   "82b02cf0fb7452ad246a2a2e682ca52dc90ef80a2ca338d659feb6d182c6b31d"
    sha256 cellar: :any, x86_64_linux:  "c2173a50782078aff526c0fc51cf1a35599f78dd3239fa322814621251f0ec31"
  end

  depends_on "pkgconf" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"

  on_linux do
    depends_on "pulseaudio"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--disable-silent-rules",
                          *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    resource "homebrew-mystique.s3m" do
      url "https://api.modarchive.org/downloads.php?moduleid=54144#mystique.s3m"
      sha256 "e9a3a679e1c513e1d661b3093350ae3e35b065530d6ececc0a96e98d3ffffaf4"
    end

    resource("homebrew-mystique.s3m").stage do
      output = shell_output("#{bin}/openmpt123 --probe mystique.s3m")
      assert_match "Success", output
    end
  end
end
