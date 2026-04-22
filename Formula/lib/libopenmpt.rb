class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.8.6+release.autotools.tar.gz"
  version "0.8.6"
  sha256 "caa2fa959e389f4374d9e2df3af5c633452c12dd80442cba2e89cb7ff2b93c5b"
  license "BSD-3-Clause"
  compatibility_version 1

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3100a44cac42a5301a265ce93e28a5278832b9eae826f0025a811ca6736661c6"
    sha256 cellar: :any,                 arm64_sequoia: "37aaac41ea5818d3435dda2c7673a5d78b42c3347a27d2ef0399da6ced4b19c5"
    sha256 cellar: :any,                 arm64_sonoma:  "7f8b1bb0934499969b12f35bd6e0a2a97c3aadf92996d4b5e0fa58feae889df8"
    sha256 cellar: :any,                 sonoma:        "fa4fec4c54ea6203a9a46d4d288a08d69e1d1bac1cd2ec99a03fd2d194fdc943"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b99ca507fe526b56d93681d4681f426a469f21d4d58a89d57347935c98fb75a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edd7140d0223a7266f3e6019321dc800dff590e47cdfe7b4cd416e5d9d818abd"
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
