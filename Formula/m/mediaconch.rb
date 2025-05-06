class Mediaconch < Formula
  desc "Conformance checker and technical metadata reporter"
  homepage "https://mediaarea.net/MediaConch"
  url "https://mediaarea.net/download/binary/mediaconch/25.04/MediaConch_CLI_25.04_GNU_FromSource.tar.bz2"
  sha256 "800d076ca374a0c954c928f471761fb000b36b7df9d8e1d1bb03b233edff8857"
  license "BSD-2-Clause"

  livecheck do
    url "https://mediaarea.net/MediaConch/Download/Source"
    regex(/href=.*?mediaconch[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "192df199a6d3d806ba48aee44ed9bbfa171777699d5bbe4e2c9368f7a0b5667d"
    sha256 cellar: :any,                 arm64_sonoma:  "677887e14ce2feab7e110e7e8ef7a07d507da8c055d57008b11263516e3e893a"
    sha256 cellar: :any,                 arm64_ventura: "80a7eb928adcfd633886fde7f945322e7c34767d6cab943fe787331aff3fdf47"
    sha256 cellar: :any,                 sonoma:        "7f5dd6a3e6e60731a37164f8745b42002e4aaf710c797c5664d17454b9d30454"
    sha256 cellar: :any,                 ventura:       "54997bdec0585a932b7e2e7f8d7cb10e48ddde5ef5a385ed0a2f04f5ce33ac33"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0b2a5bf4219731fbb34eaa994e53fa25874448ed49dee323c9cfbdbcf5321cc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c11e7b0b33b4072bdeb52e5c3acffbb2b86c677458ee23a5e981c0878f21fccc"
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
