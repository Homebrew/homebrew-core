class Libewf < Formula
  desc "Library for support of the Expert Witness Compression Format"
  homepage "https://github.com/libyal/libewf"
  # The main libewf repository is currently "experimental".
  # See discussions in this issue: https://github.com/libyal/libewf/issues/127
  url "https://github.com/libyal/libewf-legacy/releases/download/20140816/libewf-20140816.tar.gz"
  sha256 "6b2d078fb3861679ba83942fea51e9e6029c37ec2ea0c37f5744256d6f7025a9"
  license "LGPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^(?:libewf[._-])?v?(\d+(?:\.\d+)*)$/i)
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ec8c3c0ffa57df2d43c53a5065ef5f1b40a4623c530a2e29f20fbd99c22df90f"
    sha256 cellar: :any,                 arm64_sequoia: "6869e95d17a26169a28afe5bf0f53db15a9f845d33353648488cd7f9cf1e0f6e"
    sha256 cellar: :any,                 arm64_sonoma:  "09be901af33844926f5c24a55652e11288f32dcdc63981de7bdc85dfb183238c"
    sha256 cellar: :any,                 sonoma:        "1b2e461e480ef015de567fd9f9916601cd5229755c6910b13c856c0ef0676d41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "841da9d3b3197875feffc6ee142edb398a9389f8675d1fdc38310088bfef67e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f52e9116f349a9f1889a7b006dac88b00e54d80cf908afa81d351f3d84951e4"
  end

  head do
    url "https://github.com/libyal/libewf.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "openssl@3"

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
