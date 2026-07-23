class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.8.7+release.autotools.tar.gz"
  version "0.8.7"
  sha256 "275c29ef47be9992f62a35fcc96f7ca05c06d2fd05c9298b8dee9f743f75b089"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "44c2f214834049b267bfc0f60c83ea55a075fc6a8bd47c1e519dc2cb0d15bf40"
    sha256 cellar: :any,                 arm64_sequoia: "bc708899711a61484b79d6d4321e7f563be779b8cf0c440c8c272bfb41dd2546"
    sha256 cellar: :any,                 arm64_sonoma:  "01ff6518ccedcabeb522ad3e6036211d5f616fbcb6df95554e6f68ad672378a7"
    sha256 cellar: :any,                 sonoma:        "59a042bde6f7e62f335531818fd2f56e5d699c437558a8259aae594a2b5e5d27"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f244118a7c1632090a2ad16651f3d539cc1559cb87a73f15e9e1ef23dbb21429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "764f762cfe1d332f9bf4a5affdb9707df29218e1c25abff5d5cc09c8921b8a28"
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
