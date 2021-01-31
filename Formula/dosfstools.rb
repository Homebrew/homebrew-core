class Dosfstools < Formula
  desc "Tools to create, check and label file systems of the FAT family"
  homepage "https://github.com/dosfstools"
  url "https://github.com/dosfstools/dosfstools/releases/download/v4.2/dosfstools-4.2.tar.gz"
  sha256 "64926eebf90092dca21b14259a5301b7b98e7b1943e8a201c7d726084809b527"
  license "GPL-3.0-or-later"
  head "https://github.com/dosfstools/dosfstools.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6a2413a2efbaf76112cb88e3531b4e57c826423c276eeb5ed055a4ece39d9426" => :big_sur
    sha256 "df48192564cfabe5d9682029032fcc32a62871a7f9f3200503be6b2710073a2a" => :arm64_big_sur
    sha256 "c537f560096a325d904edb80218af9c113ad365ae3c39c9b1b3393aa38418885" => :catalina
    sha256 "a12605487c15e462c7ae652bb3f1587d254fc0001bfbae9261903c9f85542c2e" => :mojave
    sha256 "44d8a1baa92d553ec9c24c1152c875b0f7d3730146d3decf4cdfa8f7b1516434" => :high_sierra
    sha256 "b14dc5d79955f0ee586a33c7e265df2def55b1c64b7eb123539fce827cdeb6ec" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build
  depends_on "pkg-config" => :build

  # remove in next release
  # https://github.com/dosfstools/dosfstools/pull/158
  patch do
    url "https://github.com/dosfstools/dosfstools/commit/8a917ed2afb2dd2a165a93812b6f52b9060eec5f.patch?full_index=1"
    sha256 "73019e3f7852158bfe47a0105eb605b4df4a10ca50befc02adf50aed11bd4445"
  end

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}",
                          "--without-udev",
                          "--enable-compat-symlinks"
    system "make", "install"
  end

  test do
    system "dd", "if=/dev/zero", "of=test.bin", "bs=512", "count=1024"
    system "#{sbin}/mkfs.fat", "test.bin", "-n", "HOMEBREW", "-v"
    system "#{sbin}/fatlabel", "test.bin"
    system "#{sbin}/fsck.fat", "-v", "test.bin"
  end
end
