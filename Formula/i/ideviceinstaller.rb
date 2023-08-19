class Ideviceinstaller < Formula
  desc "Tool for managing apps on iOS devices"
  homepage "https://www.libimobiledevice.org/"
  url "https://github.com/libimobiledevice/ideviceinstaller/releases/download/1.1.1/ideviceinstaller-1.1.1.tar.bz2"
  sha256 "deb883ec97f2f88115aab39f701b83c843e9f2b67fe02f5e00a9a7d6196c3063"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fb42f5fc7e6da997dc22dd68fe9c57a711250259c737992eeb162cfe871cce99"
    sha256 cellar: :any,                 arm64_monterey: "e5bf0e5ed6aad688593878bdf8e78c5aa84530ee053f5ea21ad433cf99f59873"
    sha256 cellar: :any,                 arm64_big_sur:  "30f56186281509d1f77d7a00cbcd1f313cd80135e3f9e2a235ca649f9a23e5f1"
    sha256 cellar: :any,                 ventura:        "d99cfeb0873b28db4ded6c9fdeb4ba29aa7603a20a284444752ca97c6e7af3b6"
    sha256 cellar: :any,                 monterey:       "e6e374f35c4eeb37763e7755228c108ee96024b8599943fa741450be35915d93"
    sha256 cellar: :any,                 big_sur:        "6d98523b90770662e350311c375f1157ac0c708769ce2145036aeed451e26621"
    sha256 cellar: :any,                 catalina:       "6ee12db78e8c224c0eb0cf88eb4f43242eb1ba672eb006636273b99b75b02a87"
    sha256 cellar: :any,                 mojave:         "6ed5e4f7ace33fd5f4d1b4c6b9f0fd519836080e170b981e63942087698351c6"
    sha256 cellar: :any,                 high_sierra:    "0dfe944eaa47cad87ad22f70dbbcefdb6b27bbeb83ca1f7a229827c03054c07c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e225e3d9f0e6508b4fb73d9e7ea5eaec71b75d9d7ca7ac591adcfb3b9fd324fc"
  end

  head do
    url "https://git.sukimashita.com/ideviceinstaller.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libimobiledevice"
  depends_on "libplist"
  depends_on "libzip"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ideviceinstaller --help |grep -q ^Usage"
  end
end
