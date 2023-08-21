class Libewf < Formula
  desc "Library for support of the Expert Witness Compression Format"
  homepage "https://github.com/libyal/libewf"
  # The main libewf repository is currently "experimental".
  # See discussions in this issue, https://github.com/libyal/libewf/issues/127
  url "https://github.com/libyal/libewf-legacy/releases/download/20140813/libewf-20140813.tar.gz"
  sha256 "dbfdf1bbea5944b014c2311cce4615d92b2b6b91c8401eef8640de9f3e75845b"
  license "LGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8def2a9a27530366a68cd979fca3d18113d5910d783440826849da7029e1567e"
    sha256 cellar: :any,                 arm64_monterey: "9651ec9988df7c9f8e262de3b3c66e509b4e73615b35b704b460296b114a20b5"
    sha256 cellar: :any,                 arm64_big_sur:  "136dd66a148431c3cb2aa1a0ddd8873815246c71ebcb1f166a2a1f9b7e07c3c0"
    sha256 cellar: :any,                 ventura:        "5d3521a54bfd559f3d72f8f0103d99ff4ba924c926cc47581ef94c68f972a4f0"
    sha256 cellar: :any,                 monterey:       "dc0e9f340c83d755a5f8011af324da26e023910f8f8febd9649f4d08f8570c57"
    sha256 cellar: :any,                 big_sur:        "89db32a46a3c5f233aaf2770bdc9458cff5a1389fd613a93c5f9f49959e0564c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2843f7499b6e04783446e8bb65cd09d5908c01d979d025d85692fc9ea958877a"
  end

  head do
    url "https://github.com/libyal/libewf.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    if build.head?
      system "./synclibs.sh"
      system "./autogen.sh"
    end

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-libfuse=no
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ewfinfo -V")
  end
end
