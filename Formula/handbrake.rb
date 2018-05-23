class Handbrake < Formula
  desc "Open-source video transcoder available for Linux, Mac, and Windows"
  homepage "https://handbrake.fr/"
  url "https://download.handbrake.fr/releases/1.1.0/HandBrake-1.1.0-source.tar.bz2"
  sha256 "a02e7c6f8bd8dc28eea4623663deb5971dcbca1ad59da9eb74aceb481d8c40da"
  head "https://github.com/HandBrake/HandBrake.git"

  bottle do
    sha256 "66c8c4eff41eb5116fe8f868de296348e583975468155897a157153042d2a143" => :high_sierra
    sha256 "9c927a8062dd2a2674ed809f44a65090bc7527227906967e04429769f17d6644" => :sierra
    sha256 "cc8e3b2af4253294765ecab07bce0267674bf2ece7f749b97016af099d7f5269" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "cmake" => :build
  depends_on "libtool" => :build
  depends_on "nasm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@2" => :build
  depends_on "yasm" => :build

  def install
    # -march=native causes segfaults
    # Reported 23 May 2018 https://github.com/HandBrake/HandBrake/issues/1351
    ENV["HOMEBREW_OPTFLAGS"] = "-march=#{Hardware.oldest_cpu}" unless build.bottle?

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
