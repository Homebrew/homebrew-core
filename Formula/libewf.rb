class Libewf < Formula
  desc "Library for support of the Expert Witness Compression Format"
  homepage "https://github.com/libyal/libewf"
  # The main libewf repository is currently "experimental".
  # See discussions in this issue, https://github.com/libyal/libewf/issues/127
  url "https://github.com/libyal/libewf-legacy/releases/download/20140813/libewf-20140813.tar.gz"
  sha256 "dbfdf1bbea5944b014c2311cce4615d92b2b6b91c8401eef8640de9f3e75845b"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3df048c0a05b7b49154289de3cbaa1a0fa7197a5383ce24a4b65a3be39ebc5ac"
    sha256 cellar: :any,                 arm64_monterey: "7407568f70dcabf8cc76832250ed36d437966be3c865ec89d060d352fd249326"
    sha256 cellar: :any,                 arm64_big_sur:  "937eea6b5a11fb0855c7eb793b8ec3066a1ac06752ee3c7a9eaa0c7247a05d48"
    sha256 cellar: :any,                 ventura:        "2904c88b892db2bb42b27002baf35d5af1fc02de5c68d00a91c47aa0c720fa60"
    sha256 cellar: :any,                 monterey:       "42e44287e857a5cc4dda58bf7c54167a901a985a9fce34314994ee3b2e1b4596"
    sha256 cellar: :any,                 big_sur:        "72364ba1d62b1f7ea9e2a1197e926e59975c4c641bf7ea638ebef05621e79967"
    sha256 cellar: :any,                 catalina:       "40e02197afb43ee61393f4708c7383a478979fcd858fda648acc208aafd3dd33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b976fbecc550d49aa69a3a49c0e1b6015a4fa6838a6f3001ce160a4ec12bb874"
  end

  head do
    url "https://github.com/libyal/libewf.git", branch: "main"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

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
