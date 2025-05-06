class Ideviceinstaller < Formula
  desc "Tool for managing apps on iOS devices"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/ideviceinstaller/releases/download/1.1.1/ideviceinstaller-1.1.1.tar.bz2"
  sha256 "deb883ec97f2f88115aab39f701b83c843e9f2b67fe02f5e00a9a7d6196c3063"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/libimobiledevice/ideviceinstaller.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "42ce06edd2a59ca8e25f460c6d66689c04587f4779bf4ef4f965b5c7d01b89c4"
    sha256 cellar: :any,                 arm64_sonoma:   "818061a6b3ede66696892086a119faa1df036d6d4a3242672fdb955db0d23e6c"
    sha256 cellar: :any,                 arm64_ventura:  "dfaf6de5dc0578c882412ef904195d77a6aacf7f1b9b28855ba5d8610ce17ca1"
    sha256 cellar: :any,                 arm64_monterey: "64803ee9f44f71a81476e4f609a96be3c33276da4eaa07f5f4c402e758fbd18c"
    sha256 cellar: :any,                 arm64_big_sur:  "b76c11584f52a003b8b473a8b6e74a44244255b372d129a9dc0c89ae920a6c6b"
    sha256 cellar: :any,                 sonoma:         "904a3bd25f933d636a094b0f16aaa8559fddac5c50f13e749b533c02f7717de6"
    sha256 cellar: :any,                 ventura:        "cca7171c1e51ae86824029858e05c382a4f8088644aa0ac1d075c8d8a901b5ee"
    sha256 cellar: :any,                 monterey:       "baade9b3f29b7de45b0ddfd66f911eadaba2b7d4a2fe6601e69f660757400ff7"
    sha256 cellar: :any,                 big_sur:        "76b96ca732ae1bbba325139477cca6fe6f601cb62f0435232e497d619c56d828"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0f75dd2a9a73912f8e655a54be16b59e92a99db898d95bd482dde4d2f434d6f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85e4dd1751770e3068d164a48202b714923ac6acb344934f67ee2c9b6bd5b375"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libimobiledevice"
  depends_on "libplist"
  depends_on "libzip"

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "Manage apps on iOS devices", shell_output("#{bin}/ideviceinstaller --help")
  end
end
