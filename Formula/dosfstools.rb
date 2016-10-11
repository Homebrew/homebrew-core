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
  bottle do
    cellar :any_skip_relocation
    sha256 "9977fa27a16cab4772e9ab528053df05247718b40c4fe0029b1f044174e03a21" => :sierra
    sha256 "80ff9e3d9a13ee9b4af60f0ec099755bf9cc5f08927e8f5e5ed9e9deb15f8de5" => :el_capitan
    sha256 "1272b2a6cd3264e5d69da30e6f74add66ca7f6f9eb2eb30af7ba738c41233fb5" => :yosemite
    sha256 "fc128348728cfb7b634e5d286dc69aa954aee9dc79cb6dec0c27de31ebc1c264" => :mavericks
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
