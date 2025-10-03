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
    sha256 cellar: :any,                 arm64_tahoe:    "8df05003fb3079d4e806f1edd40c7230f836e3e45724d39db7e2651d6e89ff24"
    sha256 cellar: :any,                 arm64_sequoia:  "cc1ee22a4c919dcbcc09d7b8e6c63c212648cbb47d709271390a5b0ffab316f9"
    sha256 cellar: :any,                 arm64_sonoma:   "f921e6618b878d66acb4b02db137244115b0e721dd935ae5b151b681000ea86c"
    sha256 cellar: :any,                 arm64_ventura:  "0c994929653ecf3f7a487f17231db932301058a5883b0e6076dea4ba4b8468bd"
    sha256 cellar: :any,                 arm64_monterey: "9b990ae7f7866c4f3600f0ab65f88782812a2bc47e83d0a869081ca87e594746"
    sha256 cellar: :any,                 sonoma:         "85fbf4280d4b14162dbee0956d5fc13e61bd018d183e920fff921d157dff06ee"
    sha256 cellar: :any,                 ventura:        "d67b1dbed6b0bb1b20eeb6d294451821bd19deb21b79d1ba8cdaf94d4eb34913"
    sha256 cellar: :any,                 monterey:       "e63d530c15de2669b9957557fe72585795f783fa66684b492dc9c6c0e75d4f06"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "189d67460fe4ede4cbfabdb18ea999ca1b170e2577457c2373cce8eec2dd3623"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3ebd71fc7c67743ebcfa1cb95debe60db4d085ca3235b0c6cebec9836b13dba"
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
  uses_from_macos "zlib"

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
