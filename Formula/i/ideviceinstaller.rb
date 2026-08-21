class Ideviceinstaller < Formula
  desc "Tool for managing apps on iOS devices"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/ideviceinstaller/releases/download/1.2.0/ideviceinstaller-1.2.0.tar.bz2"
  sha256 "26115288e50d003bbb7d23c05441c54ea69b255974303bfd44fef6943e042f94"
  license "GPL-2.0-or-later"
  head "https://github.com/libimobiledevice/ideviceinstaller.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "40252ee42c978cd9772f4722a842d6df4c740bdc75016bc12a43d048177cbd9e"
    sha256 cellar: :any,                 arm64_sequoia: "86009ba2f98d2f62f1ecf06050ec1bae498563cc798ef8145523683ac0610a9b"
    sha256 cellar: :any,                 arm64_sonoma:  "b0b1ee1e1e2b51f9f26bdc5734850a520caf8d492dd6ba1f3ad89d230a379142"
    sha256 cellar: :any,                 sonoma:        "b499a23005d13e350b43f4e72fe58c2ce52656d998c8dc5f8477a7ab28a4d05d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb0bf7d7b34adb781f9228da0f456d54624f8c8bf3a7689931a391d6735fe69d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f9ad95e575560317e3e1dd048d120baab443565b20338c41f070bced2b4d25f"
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
