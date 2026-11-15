class Hivex < Formula
  desc "Library and tools for extracting the contents of Windows Registry hive files"
  homepage "https://libguestfs.org"
  url "https://download.libguestfs.org/hivex/hivex-1.3.25.tar.gz"
  sha256 "10fe3b31c0c6ee8bd82749d3161321bfc2e2f3b986a77cdce1ef8987d1296605"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-only"]

  livecheck do
    url "https://download.libguestfs.org/hivex/"
    regex(/href=.*?hivex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c5487e5f00f415838d08d5f85332e7050263ebd865661068a3b287c079a2558a"
    sha256 cellar: :any, arm64_tahoe:       "388c7e0f254b34c93a7b4c06461cecdc74da595a13cdd8e5fc1f9f394341a117"
    sha256 cellar: :any, arm64_sequoia:     "92f96d59734b9ff898f9f6dd03279ad085cce2a0c1a5f8c3385c4530590a09ed"
    sha256               arm64_linux:       "cc78ca46f50b0e79a7a4d52b1836b24b13f3915aaf106093889292bd7ed17315"
    sha256               x86_64_linux:      "f0b14ab9bd2b5be5bce7e53252ae80fdc4210e1ddc4cfa9a4a5200d281fce144"
  end

  depends_on "pkgconf" => :build
  depends_on "readline"

  uses_from_macos "pod2man" => :build
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  deny_network_access!

  def install
    # Work around `-Wl,-M` usage. This was fixed in parent project (libguestfs) but not yet in hivex
    # https://github.com/libguestfs/libguestfs/commit/e17d794d11090b2f221bfd93acb6a8da046a2540
    inreplace "configure", '"-Wl,-M -Wl,"', '"-Wl,-map -Wl,"' if DevelopmentTools.clang_build_version >= 1500

    args = %w[
      --disable-ocaml
      --disable-perl
      --disable-python
      --disable-ruby
      --disable-silent-rules
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
    (pkgshare/"test").install "images/large"
  end

  test do
    assert_equal "305419896", shell_output("#{bin}/hivexget #{pkgshare}/test/large 'A\\A giant' B").chomp
  end
end
