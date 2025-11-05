class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/25.04/MediaConch_CLI_25.04_GNU_FromSource.tar.bz2"
  sha256 "800d076ca374a0c954c928f471761fb000b36b7df9d8e1d1bb03b233edff8857"
  license "BSD-2-Clause"
  revision 1

  livecheck do
    url "https://mediaarea.net/MediaConch/Download/Source"
    regex(/href=.*?mediaconch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "844ab2be12e5e698eca1b88045f8daddbd39ac8b01498ea1c5617914d7f28041"
    sha256 cellar: :any,                 arm64_sequoia: "a25abff496997bda4f16f34850447b72f0339236e563d66f478678457b703aad"
    sha256 cellar: :any,                 arm64_sonoma:  "360ba609196b870ead90356eba2d6c586b4de5b1049582edc85bbdde89e4066f"
    sha256 cellar: :any,                 sonoma:        "fbef1a650094552ecc64f13889ac9a25f0f9c5dd40fdd3ad738c953eaec8bf3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f56ef42b6c53531222833ebe2745d1c04ea8bcd113a853cb2f560806821bf26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0632cb17d9d660d07aa5ccf1d69b9c88801443af6bacb2e5e99b4ef55bde6476"
  end

  depends_on "pkgconf" => :build
  depends_on "jansson"
  depends_on "libevent"
  depends_on "libmediainfo"
  depends_on "libzen"
  depends_on "sqlite"

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"
  uses_from_macos "zlib"

  def install
    cd "MediaConch/Project/GNU/CLI" do
      system "./configure", *std_configure_args
      system "make", "install"
    end
  end

  test do
    output = shell_output("#{bin}/mediaconch #{test_fixtures("test.mp3")}")
    assert_match "N/A! #{test_fixtures("test.mp3")}", output

    assert_match version.to_s, shell_output("#{bin}/mediaconch --version")
  end
end
