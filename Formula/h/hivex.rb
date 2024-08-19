class Hivex < Formula
  desc "Library and tools for extracting the contents of Windows Registry hive files"
  homepage "https://libguestfs.org"
  url "https://download.libguestfs.org/hivex/hivex-1.3.23.tar.gz"
  sha256 "40cf5484f15c94672259fb3b99a90bef6f390e63f37a52a1c06808a2016a6bbd"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-only"]

  livecheck do
    url "https://download.libguestfs.org/hivex/"
    regex(/href=.*?hivex[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "4e525ec1b9fafd80529302d6b215180d9666b9ab28883951976dd9299ed3d5b0"
    sha256 cellar: :any, arm64_ventura:  "5b762d9899d0ae209079abae74a4f18d7e9f29824cf7c6c5144f6626d87debba"
    sha256 cellar: :any, arm64_monterey: "ad381758881bcfa6a41864c472eacd4476d7a21ddef776b78d285d7139cb93c9"
    sha256 cellar: :any, arm64_big_sur:  "837c408efabee26bb2edb3f354bfcff31987b57d1275acd0988bd2cd1ed0a5f8"
    sha256 cellar: :any, sonoma:         "3bfee8692a76f1e58bf191730385eebb91ffa4b497f5ac4aa6d17c87f283b0dd"
    sha256 cellar: :any, ventura:        "65a4a0fb292c7d4989e08984b39470077a24950d75b54e18145b258d97afa28f"
    sha256 cellar: :any, monterey:       "cc5e7f4536be0fe9560b4b1808c9015754d3e81d530866f7c349463b25d0479e"
    sha256 cellar: :any, big_sur:        "758e1d6c28c1dfbe725b99fe7f3fe339ff8b1150f5c85e3f9368a5e1386aad45"
    sha256               x86_64_linux:   "b080edd6e833144a7e66f2346171dd28a392cfec2013979bc4b6dee9c4c93156"
  end

  depends_on "pkg-config" => :build
  depends_on "readline"

  uses_from_macos "pod2man" => :build
  uses_from_macos "libxml2"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Use `-ld_classic` to work around `-Wl,-M` usage
    ENV.append "LDFLAGS", "-Wl,-ld_classic" if DevelopmentTools.clang_build_version >= 1500

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
