class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows."
  homepage "https://handbrake.fr/"
  head "https://github.com/HandBrake/HandBrake.git"

  stable do
    url "https://handbrake.fr/mirror/HandBrake-1.0.7.tar.bz2"
    sha256 "ffdee112f0288f0146b965107956cd718408406b75db71c44d2188f5296e677f"

    resource "freetype" do
      url "https://downloads.sourceforge.net/project/freetype/freetype2/2.6.5/freetype-2.6.5.tar.bz2",
          :using => :nounzip
      sha256 "e20a6e1400798fd5e3d831dd821b61c35b1f9a6465d6b18a53a9df4cf441acf0"
    end

    resource "fribidi" do
      url "https://www.fribidi.org/download/fribidi-0.19.7.tar.bz2",
          :using => :nounzip
      sha256 "08222a6212bbc2276a2d55c3bf370109ae4a35b689acbc66571ad2a670595a8e"
    end

    resource "harfbuzz" do
      url "https://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.3.0.tar.bz2",
          :using => :nounzip
      sha256 "b04be31633efee2cae1d62d46434587302554fa837224845a62565ec68a0334d"
    end

    resource "jansson" do
      url "http://www.digip.org/jansson/releases/jansson-2.6.tar.bz2",
          :using => :nounzip
      sha256 "d2cc63ee7f6dcda6c9a8f0b558f94b8f25f048706b7cbd6a79d3e877b738cd4d"
    end

    resource "lame" do
      url "https://www.mirrorservice.org/sites/distfiles.macports.org/HandBrake/lame-3.98.tar.gz",
          :using => :nounzip
      sha256 "40235e84dfe4760ad3f352590a64b7bda1502a386c97d06229df356426e37686"
    end

    resource "libass" do
      url "https://github.com/libass/libass/releases/download/0.13.2/libass-0.13.2.tar.gz",
          :using => :nounzip
      sha256 "8baccf663553b62977b1c017d18b3879835da0ef79dc4d3b708f2566762f1d5e"
    end

    resource "libav" do
      url "https://libav.org/releases/libav-12.tar.gz",
          :using => :nounzip
      sha256 "ca5cb22ba660f0bdc47817fdb9d99059a71f9eb0776c68cf8bef769a5ccc7534"
    end

    resource "libbluray" do
      url "https://download.videolan.org/pub/videolan/libbluray/0.9.3/libbluray-0.9.3.tar.bz2",
          :using => :nounzip
      sha256 "a6366614ec45484b51fe94fcd1975b3b8716f90f038a33b24d59978de3863ce0"
    end

    resource "libdvdnav" do
      url "https://ftp.osuosl.org/pub/blfs/conglomeration/libdvdnav/libdvdnav-5.0.1.tar.bz2",
          :using => :nounzip
      sha256 "72b1cb8266f163d4a1481b92c7b6c53e6dc9274d2a6befb08ffc351fe7a4a2a9"
    end

    resource "libdvdread" do
      url "https://www.mirrorservice.org/sites/distfiles.macports.org/HandBrake/libdvdread-5.0.0-6-gcb1ae87.tar.gz",
          :using => :nounzip
      version "5.0.0-6-gcb1ae87"
      sha256 "d2e4200c3c5d5f812892f9c14851c94e2f707d54e7328946c6397ac999f15f17"
    end

    resource "libogg" do
      url "https://www.mirrorservice.org/sites/distfiles.macports.org/HandBrake/libogg-1.3.0.tar.gz",
          :using => :nounzip
      sha256 "a8de807631014615549d2356fd36641833b8288221cea214f8a72750efe93780"
    end

    resource "libsamplerate" do
      url "https://www.mirrorservice.org/sites/distfiles.macports.org/HandBrake/libsamplerate-0.1.4.tar.gz",
          :using => :nounzip
      sha256 "4b4af3ecaee05c8875a9b113c6a2f816f06f283fb882914e57b21c0b08b67b75"
    end

    resource "libtheora" do
      url "https://www.mirrorservice.org/sites/distfiles.macports.org/HandBrake/libtheora-1.1.0.tar.bz2",
          :using => :nounzip
      sha256 "74be9fe9f85d18c45bdcbb018cebf12c74e2234aeecb4d4c4cb92d80bdd287e2"
    end

    resource "libvorbis-aoutv" do
      url "https://www.mirrorservice.org/sites/distfiles.macports.org/HandBrake/libvorbis-aotuv_b6.03.tar.bz2",
          :using => :nounzip
      version "b6.03"
      sha256 "95455420f07e4b3abdf32bda9f5921e9ed3f1afdc3739098dc090150a42fd7fd"
    end

    resource "libvpx" do
      url "https://ftp.osuosl.org/pub/blfs/conglomeration/libvpx/libvpx-1.5.0.tar.bz2",
          :using => :nounzip
      sha256 "306d67908625675f8e188d37a81fbfafdf5068b09d9aa52702b6fbe601c76797"
    end

    resource "libxml2" do
      url "https://www.mirrorservice.org/sites/distfiles.macports.org/HandBrake/libxml2-2.7.7.tar.gz",
          :using => :nounzip
      sha256 "af5b781418ba4fff556fa43c50086658ea8a2f31909c2b625c2ce913a1d9eb68"
    end

    resource "opus" do
      url "https://ftp.osuosl.org/pub/xiph/releases/opus/opus-1.1.3.tar.gz",
          :using => :nounzip
      sha256 "58b6fe802e7e30182e95d0cde890c0ace40b6f125cffc50635f0ad2eef69b633"
    end

    resource "x264" do
      url "https://download.videolan.org/pub/pub/x264/snapshots/x264-snapshot-20160920-2245-stable.tar.bz2",
          :using => :nounzip
      sha256 "6ba2d848eabbca0d9d2c2a12b263e02f856a81fce87fbc74df52a1097c88e39c"
    end

    resource "x265_2.1" do
      url "https://download.videolan.org/pub/videolan/x265/x265_2.1.tar.gz",
          :using => :nounzip
      sha256 "88fcb9af4ba52c0757ac9c0d8cd5ec79951a22905ae886897e06954353d6a643"
    end
  end

  bottle do
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
    resources.each { |r| (buildpath/"download").install r }
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
