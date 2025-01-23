class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/24.06/MediaConch_CLI_24.06_GNU_FromSource.tar.bz2"
  sha256 "2dd68a260ea84fe23031c2caa121ede850f34a8c733e53237205bd018af0b9d9"
  license "BSD-2-Clause"

  livecheck do
    url "https://mediaarea.net/MediaConch/Download/Source"
    regex(/href=.*?mediaconch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "10ce29cf594e58d4fc6ca0b3cc2d1f5333adf9f7440fdeda05dc0d1c3aaea6e1"
    sha256 cellar: :any,                 arm64_sonoma:  "d0880640ba261dc82a8f91885b08c1474203a9bd2f4e497c3d5fdb24e51f62ef"
    sha256 cellar: :any,                 arm64_ventura: "6bf6ef2c0295778a884a55842ab43ec96de05ff3974788cb9bde1a2f74cc4682"
    sha256 cellar: :any,                 sonoma:        "ff7b48bac8502ded512fffc37eaf892652b1a96be65930d8f890adcc243f1a0c"
    sha256 cellar: :any,                 ventura:       "c7fb0337d0eba78b2bb9068d56e9d92b4e024905e0c2f32c693c9197b2cb4f2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3cf59eccd7e3183e0a02788a5e0a1dcc6d109221bdafa604c8c1be4338c002d7"
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
