class Hivex < Formula
  desc "Library and tools for extracting the contents of Windows Registry hive files"
  homepage "https://libguestfs.org"
  url "https://download.libguestfs.org/hivex/hivex-1.3.24.tar.gz"
  sha256 "a52fa45cecc9a78adb2d28605d68261e4f1fd4514a778a5473013d2ccc8a193c"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-only"]
  revision 1

  livecheck do
    url "https://download.libguestfs.org/hivex/"
    regex(/href=.*?hivex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "513f520b5576ba24f182a2de912bfa318f37f7f792976b5bef917af066113820"
    sha256 cellar: :any, arm64_sequoia: "8af38ad8bd4300148430887052eb5f84fdbe094a2bf1e9a049b6e5d5f344d96a"
    sha256 cellar: :any, arm64_sonoma:  "103d76ee907491f3082f1225740be40d1de8c6b8f39d3f55d417a10ea41c2522"
    sha256 cellar: :any, sonoma:        "8b0a01c675005731b25f5c38719cc69e9f3eb77bcb92c2883b88adeb90daf5c6"
    sha256               arm64_linux:   "2e399093f65da88d153957e646969f331e252eff7863a5af3e4055dbf342ed88"
    sha256               x86_64_linux:  "ffdf125155e8818f0a520df7b9da7da779737af046214192e16bf25be5774c07"
  end

  depends_on "pkgconf" => :build
  depends_on "readline"

  uses_from_macos "pod2man" => :build
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

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
