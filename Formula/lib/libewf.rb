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
    sha256 cellar: :any, arm64_golden_gate: "2d62fc084f4de25b3fe1a8384bcc0fcc4b6e086e65e2e60db752894442ae8847"
    sha256 cellar: :any, arm64_tahoe:       "f6077d81c5adc0bf4c458538df465ba3a5ea24ae1738ff050e17ec9156cb6af6"
    sha256 cellar: :any, arm64_sequoia:     "7aad689fe7db2f0b8c0aa27e8a27462ed202e2460a1b3d3576ba41033474041a"
    sha256 cellar: :any, arm64_linux:       "b2cbd0b66dcbda5e67ae8a6ea785e2acdbbfc59b5ef837d65e4881e2cdce7eb7"
    sha256 cellar: :any, x86_64_linux:      "621222b6c182d17739b1c956d8d6b53c5a65a9192c91e63d0dd6466c3a228d52"
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
