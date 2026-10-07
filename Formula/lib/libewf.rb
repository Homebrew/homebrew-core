class Libewf < Formula
  desc "Library for support of the Expert Witness Compression Format"
  homepage "https://github.com/libyal/libewf"
  # The main libewf repository is currently "experimental".
  # See discussions in this issue: https://github.com/libyal/libewf/issues/127
  url "https://github.com/libyal/libewf-legacy/releases/download/20140817/libewf-20140817.tar.gz"
  sha256 "6dbbefe68e913243dc000b9daaf59f293e33c2340024f7dfb144f1ad90b06544"
  license "LGPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(/^(?:libewf[._-])?v?(\d+(?:\.\d+)*)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1ec9dbeadfcff305be1c18d9e5b0899eafe4ad7433fc9739d901773b2804aa35"
    sha256 cellar: :any, arm64_tahoe:       "8792a4b916c961bd9b3e7de6faf86f3a10736e280a9c24f22ef5278c9046c7ad"
    sha256 cellar: :any, arm64_sequoia:     "f3d83ba7fbcf13ea2c9791cc4292a952950a97e3d03704d9a80817618b1ce33e"
    sha256 cellar: :any, arm64_linux:       "28bd71b9e943961157da7409353c1a6bcd95c851e65952a399405e756162bd4a"
    sha256 cellar: :any, x86_64_linux:      "20d57304f8cd5355fb4761a3d74d0577fbfcc50acdb867627c8f2155477b1676"
  end

  head do
    url "https://github.com/libyal/libewf.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@4"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    if build.head?
      system "./synclibs.sh"
      system "./autogen.sh"
    end

    args = %w[
      --disable-silent-rules
      --with-libfuse=no
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ewfinfo -V")
  end
end
