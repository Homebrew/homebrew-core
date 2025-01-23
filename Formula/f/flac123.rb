class Flac123 < Formula
  desc "Command-line program for playing FLAC audio files"
  homepage "https://github.com/flac123/flac123"
  url "https://github.com/flac123/flac123/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "c09676dce51383ce4fe7a553e67f4369918cf40ee6d922e585e50c11bce9e227"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "9e700b54a0a992a7383e2eb9bceccf66da63c51895d58931c37512334f0ec690"
    sha256 cellar: :any,                 arm64_sonoma:   "a1c6d6d2d1d764ba31918fb6f0c50756771a04ee3868944484f5bbdd05775ecf"
    sha256 cellar: :any,                 arm64_ventura:  "8a3a466680bff98485b1be1f5ec2be0d68522debbec2206d08b122981af0abfb"
    sha256 cellar: :any,                 arm64_monterey: "3b98b988e1528c56b970fa9984663916ea59173ca4b6fd09979be8832abe5ab0"
    sha256 cellar: :any,                 sonoma:         "3a1075db8609cf8bdd5e676898f7723800590d24d06fb2cbcd20bb15ec4efa81"
    sha256 cellar: :any,                 ventura:        "92b75dfcc6ab5d40cc211bb857c8c1fa1b769173ab8c0a3e2064298ae177a872"
    sha256 cellar: :any,                 monterey:       "ae9674662b893127e538689b04c7cb2904e7199997fd679444eeb471ba69901c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20f164d6d0294b5ca226c8a5e9b8fec7e0c7a517cc4ab38c282585c53600d0d0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  depends_on "flac"
  depends_on "libao"
  depends_on "libogg"
  depends_on "popt"

  def install
    ENV["ACLOCAL"] = "aclocal"
    ENV["AUTOMAKE"] = "automake"
    system "aclocal"
    system "automake", "--add-missing"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install", "CC=#{ENV.cc}"
  end

  test do
    driver = OS.mac? ? "macosx" : "oss"
    system bin/"flac123", "-d=#{driver}"
  end
end
