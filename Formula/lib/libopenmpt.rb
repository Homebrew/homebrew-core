class Libopenmpt < Formula
  desc "Software library to decode tracked music files"
  homepage "https://lib.openmpt.org/libopenmpt/"
  url "https://lib.openmpt.org/files/libopenmpt/src/libopenmpt-0.7.5+release.autotools.tar.gz"
  version "0.7.5"
  sha256 "59dd550ca245a4a48e6fbf1e2f6176190125f07fe5d044738f2e4e6c231dff0a"
  license "BSD-3-Clause"

  livecheck do
    url "https://lib.openmpt.org/files/libopenmpt/src/"
    regex(/href=.*?libopenmpt[._-]v?(\d+(?:\.\d+)+)\+release\.autotools\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "076003c96612d316af8755b15a83adee6f33e6ecc07201bdc11bd6e50b2faa56"
    sha256 cellar: :any,                 arm64_ventura:  "8727c59286b53d85311f777f144b3025d1228c5f34fa8e3f6527e57b5ba65c15"
    sha256 cellar: :any,                 arm64_monterey: "c742b6282227589aae5e73539b2f8a5ba127cdcd8ba92fa558afb8a6ad9a4671"
    sha256 cellar: :any,                 sonoma:         "fa58f1bf112bffeabb01375917cfc6b06aee4157f6ebb683dfd6682a0fac198b"
    sha256 cellar: :any,                 ventura:        "91bd6d1e45538434686f86a3456b9ff3503344f91ae3e2532fccc4d77099104b"
    sha256 cellar: :any,                 monterey:       "ce6d22a8efe976c1f0fafd9a72d85105fe5a89507397df142b5edda69a469530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf96fb9d2ec66fd170726d6da4eebe9813a38416966aea3fd510a5cc806b3b44"
  end

  depends_on "pkg-config" => :build

  depends_on "flac"
  depends_on "libogg"
  depends_on "libsndfile"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "portaudio"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pulseaudio"
  end

  fails_with gcc: "5" # needs C++17

  resource "homebrew-mystique.s3m" do
    url "https://api.modarchive.org/downloads.php?moduleid=54144#mystique.s3m"
    sha256 "e9a3a679e1c513e1d661b3093350ae3e35b065530d6ececc0a96e98d3ffffaf4"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--without-vorbisfile"
    system "make"
    system "make", "install"
  end

  test do
    resource("homebrew-mystique.s3m").stage do
      output = shell_output("#{bin}/openmpt123 --probe mystique.s3m")
      assert_match "Success", output
    end
  end
end
