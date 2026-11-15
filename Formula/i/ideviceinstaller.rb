class Ideviceinstaller < Formula
  desc "Tool for managing apps on iOS devices"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/ideviceinstaller/releases/download/1.2.0/ideviceinstaller-1.2.0.tar.bz2"
  sha256 "26115288e50d003bbb7d23c05441c54ea69b255974303bfd44fef6943e042f94"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/libimobiledevice/ideviceinstaller.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "783a52cd63a8bd83da70629412867b42951c032ab636a3e30c1623c3d9c6d68c"
    sha256 cellar: :any, arm64_tahoe:       "cba84b18352c707bb4534a221338c05b19a24998de67e3320c8d175c185ddbb4"
    sha256 cellar: :any, arm64_sequoia:     "2f2b9109bfa4982df1cd3e130ba6db7ff539a9c943811b33145b3638effb78f2"
    sha256 cellar: :any, arm64_linux:       "0595c695d0ba36875661388078864451a7c5afbd6acb680384b1442bc75b7bd0"
    sha256 cellar: :any, x86_64_linux:      "8390ecac85f7899e901d45f2acd5bf23fb6660bc6f5d04db02d81af89f53c76d"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libimobiledevice"
  depends_on "libplist"
  depends_on "libzip"

  deny_network_access!

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "Manage apps on iOS devices", shell_output("#{bin}/ideviceinstaller --help")
  end
end
