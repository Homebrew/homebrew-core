class Ffms2 < Formula
  desc "Libav/ffmpeg based source library and Avisynth plugin"
  homepage "https://github.com/FFMS/ffms2"
  url "https://github.com/FFMS/ffms2/archive/refs/tags/5.0.tar.gz"
  mirror "https://deb.debian.org/debian/pool/main/f/ffms2/ffms2_5.0.orig.tar.gz"
  sha256 "7770af0bbc0063f9580a6a5c8e7c51f1788f171d7da0b352e48a1e60943a8c3c"
  # The FFMS2 source is licensed under the MIT license, but its binaries
  # are licensed under the GPL because GPL components of FFmpeg are used.
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/FFMS/ffms2.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "03575bd3c5cd87878dc46b92f96f7e0b16ceca81b69492d2968cf596ad93778e"
    sha256 cellar: :any,                 arm64_sonoma:   "13954ff5340289c90c5db2366c1893cd48b30c62a65625df74a8df0e3340a891"
    sha256 cellar: :any,                 arm64_ventura:  "64fc6597466170a7d8c595ab3a3c9b56005f5a47c571111944012aa7dbd1e047"
    sha256 cellar: :any,                 arm64_monterey: "563a1537a4c8573205e5ca1bdaf03928c5dac901ecbdd9a2a85b6a51a300e2a1"
    sha256 cellar: :any,                 sonoma:         "8d659a7c438d83d9894c177e6f3b66aaf77535732761f9fc8db04aa4c2837f6a"
    sha256 cellar: :any,                 ventura:        "5fd68b4056bbc5a74134479eff08729bbb9cc0c3bcd0f4917236feaea232ae62"
    sha256 cellar: :any,                 monterey:       "61cd167e26cca0414ba2d91c7d09a2a9cd7056e845dc67b1f3136ebddb28abd3"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b6e2a5fe97997d41e4ad36b30bd08e240eeec11805dbdf6ae9b01c70bc559892"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c34b82acbfacbdddbf99efb5fd55d7b6e2d27498f76e62f354d275af69da706"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"

  uses_from_macos "zlib"

  def install
    system "./autogen.sh", "--enable-avresample", *std_configure_args
    system "make", "install"
  end

  test do
    resource "homebrew-videosample" do
      url "https://samples.mplayerhq.hu/V-codecs/lm20.avi"
      sha256 "a0ab512c66d276fd3932aacdd6073f9734c7e246c8747c48bf5d9dd34ac8b392"
    end

    # download small sample and check that the index was created
    resource("homebrew-videosample").stage do
      system bin/"ffmsindex", "lm20.avi"
      assert_path_exists Pathname.pwd/"lm20.avi.ffindex"
    end
  end
end
