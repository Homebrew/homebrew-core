class Libgfshare < Formula
  desc "Library for sharing secrets"
  homepage "https://github.com/kinnison/libgfshare"
  url "https://github.com/kinnison/libgfshare/archive/refs/tags/2.0.0.tar.gz"
  sha256 "91d7ea7f3e5ddb3854a38827a3f6ea7c597db03067735dc953bd31c5b90f9930"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "9e5e82d21f97532066ac859f09e1bfe2dc1fa551109f538d1e4cdc09a80d5c4a"
    sha256 cellar: :any,                 arm64_sequoia: "0fc98f80ef06554dcb6ce8b327e2deb830f59cd6d81a6e871204f3148a3c791b"
    sha256 cellar: :any,                 arm64_sonoma:  "4b5d0de0f021094a0ba3b3dde70293441e07023aed4ec5fc068991a802186a31"
    sha256 cellar: :any,                 sonoma:        "434c525551f2e403cbe28226836a20c16715e283c7b4439e1efb20a4eff10625"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd1cf741c9efe62d6498373e84a9d29b29ba0e16985721fb17d967ec5d43161f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1428a9c8652080cf16a5189f6a47c4b1feb62c2f4dbca7e688d86d0770c08802"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--disable-linker-optimisations",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    touch "test.in"
    system bin/"gfsplit", "test.in"
    system bin/"gfcombine test.in.*"
  end
end
