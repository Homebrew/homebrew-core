class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://download.handbrake.fr/releases/1.0.7/HandBrake-1.0.7.tar.bz2"
  sha256 "ffdee112f0288f0146b965107956cd718408406b75db71c44d2188f5296e677f"
  head "https://github.com/HandBrake/HandBrake.git"

  bottle do
    sha256 "defe7d13eebbcd54f269fff4fb0d600333bb14a25deea57a4605045356d74d45" => :high_sierra
    sha256 "61a9dce983af5963dc6233fadef0a4c4c79391057f71e584298172e6fe80d3dc" => :sierra
    sha256 "37c825fa81b75fa8ea85ff58b00fe152a71acaaa52d02a490a8c13766dfa33c1" => :el_capitan
    sha256 "b14c568a5f20f04f6f15805111df263dd231ad86f599af9a928aa6eaf0b4f9d7" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "yasm" => :build

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-xcode",
                          "--disable-gtk"
    system "make", "-C", "build"
    system "make", "-C", "build", "install"
  end

  test do
    system bin/"HandBrakeCLI", "--help"
  end
end
