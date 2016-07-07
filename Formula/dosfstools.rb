class Dosfstools < Formula
  desc "Tools to create, check and label file systems of the FAT family"
  homepage "https://github.com/dosfstools"
  head "https://github.com/dosfstools/dosfstools.git"

  stable do
    url "https://github.com/dosfstools/dosfstools/releases/download/v4.0/dosfstools-4.0.tar.gz"
    mirror "https://fossies.org/linux/misc/dosfstools-4.0.tar.gz"
    sha256 "25809c30403c9a945ae34827ec75df32ff55017415a720864fefccc8c8f9991f"

    # This patch restores the old defaults in versions up to v3.0.28
    patch do
      url "https://github.com/dosfstools/dosfstools/commit/1e76e577.patch"
      sha256 "824c800a589db8a779fddbbd4b8eef5a2941f838ef8f46ad390a680c8cabd2a4"
    end
  end

  option "with-compat-symlinks",
    "Symlink older names of the tools to the current ones on installation"

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build

  def install
    system "autoreconf", "-f", "-i"
    args = %W[--without-udev --prefix=#{prefix}]
    args << "--enable-compat-symlinks" if build.with? "compat-symlinks"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "dd", "if=/dev/zero", "of=test.bin", "bs=512", "count=1024"
    system "#{sbin}/mkfs.fat", "test.bin", "-n HOMEBREW", "-v"
    system "#{sbin}/fatlabel", "test.bin"
    system "#{sbin}/fsck.fat", "-v", "test.bin"
  end
end
