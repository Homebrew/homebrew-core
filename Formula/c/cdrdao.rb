class Cdrdao < Formula
  desc "Record CDs in Disk-At-Once mode"
  homepage "https://cdrdao.sourceforge.net/"
  url "https://github.com/cdrdao/cdrdao/archive/refs/tags/rel_1_2_6.tar.gz"
  sha256 "ba3eadcae7b62a709e9e23988d7fb41f822c408dcec9bd99ff1a343d1bcbc524"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^rel[._-]v?(\d+(?:[._]\d+)+)$/i)
    strategy :git do |tags, regex|
      tags.filter_map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "8447e6027230d42f921ae8ca6e40e437c5c3673af33791d49c4e531b65fd2983"
    sha256 arm64_tahoe:       "49fec427b9b1123dd7d67e0de9bd03d1a9d9b4011c1dea772db6f75477632e0c"
    sha256 arm64_sequoia:     "1d5c5d5ed4313f9e7b97e0e820496028685d0948c8fba20907d7a691a11f19c4"
    sha256 arm64_linux:       "1c5d7061c79ad8085cd44edd55975446796c3fd5849ee0e622c859c9c7b6828d"
    sha256 x86_64_linux:      "f625cd3fb76a5ce44f97e257fb0c0fe03e48ab741d43a4a816fb4b58fe7107c2"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "lame"
  depends_on "libao"
  depends_on "libvorbis"
  depends_on "mad"

  def install
    system "./autogen.sh"
    system "./configure", "--mandir=#{man}", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "ERROR: No device specified, no default device found.",
     shell_output("#{bin}/cdrdao drive-info 2>&1", 1)
  end
end
