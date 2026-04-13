class Mkfontscale < Formula
  desc "Create an index of scalable font files for X"
  homepage "https://www.x.org/"
  url "https://www.x.org/releases/individual/app/mkfontscale-1.2.3.tar.xz"
  sha256 "2921cdc344f1acee04bcd6ea1e29565c1308263006e134a9ee38cf9c9d6fe75e"
  license "X11"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "2029b136126ebb853f7c72befec91cb833b8218d54e04e1707c51a61a51d9ed8"
    sha256 cellar: :any,                 arm64_sequoia: "3dd14178ed5788bc616fd8b53017ee7b28830e06e51c2ef5fbf4a87b13157424"
    sha256 cellar: :any,                 arm64_sonoma:  "5750bbac5a5a7e478998daa857ae7794ebdc3195c243255043f5805f3344928e"
    sha256 cellar: :any,                 sonoma:        "9a091c7ef6f917c5227d1311c66a72bf9981b74aff2fcb3b2592bb2883dfe74f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84f1ae828213f379ec6558b5206633cbece34cca0d40fe965dd683591e825f0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3112c5e6d39688bdfee2ed411f2c9f9a98416a9751212f3c5bc305694ef2a0f"
  end

  depends_on "pkgconf" => :build
  depends_on "xorgproto" => :build

  depends_on "freetype"
  depends_on "libfontenc"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    configure_args = %w[
      --with-bzip2
    ]

    system "./configure", *configure_args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"mkfontscale"
    assert_path_exists testpath/"fonts.scale"
  end
end
