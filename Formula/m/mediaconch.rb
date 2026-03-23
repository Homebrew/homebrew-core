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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "8364c862db65aa723612eea3215ea4399c074701e4321b4f1a6a705b8cf6c925"
    sha256 cellar: :any,                 arm64_sequoia: "ed8e4aadeb2a94ca31f5fa04ac4409db8a3cc9f1365b4e89d0dba789e6fbff15"
    sha256 cellar: :any,                 arm64_sonoma:  "2470bb7d06e3613e3c319a2afeba16ac513e0422f7e2f898fbfbe293859dc016"
    sha256 cellar: :any,                 sonoma:        "5168de6b8b71887d861dab17f49e835d8467de0f765018b0b7cdc9380f10080e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f14fccda9ccb8ec1d160149e1a2c6ecb8cecdb62d615a7af0c622397a4232520"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75fa4fbd9aaebac202c91e5966d8054cb80ac5da0251e6954dd050649d4ed888"
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

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
