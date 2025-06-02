class MediaInfo < Formula
  desc "Unified display of technical and tag data for audio/video"
  homepage "https://mediaarea.net/"
  url "https://mediaarea.net/download/binary/mediainfo/25.04/MediaInfo_CLI_25.04_GNU_FromSource.tar.xz"
  sha256 "ecd286de77cb13ea4b6ce0ebdbbff3f3da89c67ec2d5c330d47f385a4329c5d2"
  license "BSD-2-Clause"
  head "https://github.com/MediaArea/MediaInfo.git", branch: "master"

  livecheck do
    url "https://mediaarea.net/en/MediaInfo/Download/Source"
    regex(/href=.*?mediainfo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8192fe05feba4545f5c999c17f9704b9e9d360953bb43c738f8083cf704a8247"
    sha256 cellar: :any,                 arm64_sonoma:  "04613befc701ccd6091d073267bdda7e52cb78b1982f217e7fe6a631f427821a"
    sha256 cellar: :any,                 arm64_ventura: "2831b71e363c3eb13aaa7ced2c1ffc8edff3d720753e58d7146b54583fbb0e62"
    sha256 cellar: :any,                 sonoma:        "2fc6c2dd452484b04ba831a177b96ee62daae499c648f1af93bb60fddd47b4f7"
    sha256 cellar: :any,                 ventura:       "2891d62049369ababdeab6042f2407fa02ec5ec54e4a558c9f02f6cf065c2387"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07227cdcb7c36ff2efe2956f3cfad66527e76b8542d310cbd3d27c71125ef790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a2a49777a08a3c25d247fa65df979117e4e4540a16cbcfa3e60b997a065e937"
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
