class Garmintools < Formula
  desc "Interface to the Garmin Forerunner GPS units"
  homepage "https://code.google.com/archive/p/garmintools/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/garmintools/garmintools-0.10.tar.gz"
  sha256 "ffd50b7f963fa9b8ded3223c4786b07906c887ed900de64581a24ff201444cee"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey:  "9b16bdc132c970434babd5033664d00b697deeb0fd3796c8986b1a95b7941582"
    sha256 cellar: :any,                 arm64_big_sur:   "97d99c30f0c47262b295405d79c9a0dc7bbd5b38bc67f6d7fb3e96789e0cad97"
    sha256 cellar: :any,                 monterey:        "b49cda53d64a80e61cd1de700036714c6470d5b77fad8f6320d164cb1e50db15"
    sha256 cellar: :any,                 big_sur:         "eac3d937b3281a2a172185e01a53f86fda15247168ddf7cb4dedb2a8f81b9220"
    sha256 cellar: :any,                 catalina:        "91c193c86b431bc3541b18ad33cf6793b001fc70293c50289d8fe6d978d50ca5"
    sha256 cellar: :any,                 mojave:          "ee15b7a5ca1312a9ed358f22ce2c36681eedda24ae7b855b079f196e39280101"
    sha256 cellar: :any,                 high_sierra:     "9ecdb8294089c84a229db39a395bf3f4817f185f30135a6f92711b95705ab869"
    sha256 cellar: :any,                 sierra:          "c747a668400406f6625a3832e351a4f27fd1308d8ef840120eba086d3d6adcb4"
    sha256 cellar: :any,                 el_capitan:      "dd86a8e306d3c4ebb9b94ddd4aaf60fdb79aa06fc7eb56ca95942248db33924e"
    sha256 cellar: :any,                 x86_64_yosemite: "62d2b45ae3d7ef7de9a8deaa658e12021f16b14008f1a91e8c747f84b0e803d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:    "230b31dd83d9514c35abdb2477e4f1e4941eb1c94bf394814acd46676ced1318"
  end

  depends_on "libusb-compat"

  def install
    # Fix flat namespace usage
    inreplace "configure", "${wl}-flat_namespace ${wl}-undefined ${wl}suppress", "${wl}-undefined ${wl}dynamic_lookup"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"garmin_dump"
  end
end
