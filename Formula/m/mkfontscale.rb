class Mkfontscale < Formula
  desc "Create an index of scalable font files for X"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/app/mkfontscale-1.2.3.tar.xz"
  sha256 "2921cdc344f1acee04bcd6ea1e29565c1308263006e134a9ee38cf9c9d6fe75e"
  license "X11"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "86447a62f6dfa5be3641fcc3153d8b7aa09f9660d330a06f3454d347980b4055"
    sha256 cellar: :any,                 arm64_sequoia:  "cb7cfc5fe147173c5117c3269dda15cdcacf19be6a992b9a9339ca3a91fc7495"
    sha256 cellar: :any,                 arm64_sonoma:   "6795c9f6167e00f72f72aa22ebf557a440ba85e9c4242ffba2a774dad5c8b859"
    sha256 cellar: :any,                 arm64_ventura:  "c88d40044de4b6556a64c1d679cfa377d32f0af07c7d6b344b91046910db8371"
    sha256 cellar: :any,                 arm64_monterey: "01eacad2f18ee8f35bc292d7c6dece30a4ad5a040fdbb12fd4541f843b8c438f"
    sha256 cellar: :any,                 sonoma:         "0fde03defbc5ab14a784923257a034eeb58d55e9ddd2094ce5157f84cb255b0a"
    sha256 cellar: :any,                 ventura:        "369bd2a993bc78b059ec76adc510eb212c9b3c7f0604a99d9374403d6b930202"
    sha256 cellar: :any,                 monterey:       "bf2d558740739a6f00635279dde933488d381bea05457e8fbfa92495c7820a15"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "98654a0fdb0becc676a739a84e9416bb3119c6e12b8479c8c28ca15778bd8d4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ea938e8ad6c373bad7f07d10cce369fa35345c4ae07629d46e8173357404708"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto"  => :build

  depends_on "freetype"
  depends_on "libfontenc"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    configure_args = %w[
      --with-bzip2
    ]

    system "./configure", *configure_args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"mkfontscale"
    assert_path_exists testpath/"fonts.scale"
  end
end
