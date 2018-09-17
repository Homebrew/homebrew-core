class Dosfstools < Formula
  desc "Tools to create, check and label file systems of the FAT family"
  homepage "https://github.com/dosfstools"
  head "https://github.com/dosfstools/dosfstools.git"

  stable do
    url "https://github.com/dosfstools/dosfstools/releases/download/v4.1/dosfstools-4.1.tar.gz"
    sha256 "dc49997fd9fcd6e550c1a0dd5f97863d6ded99d465c33633a2b8769f4d72a137"

    # This patch restores the old defaults in versions up to v3.0.28
    patch do
      url "https://github.com/dosfstools/dosfstools/commit/1e76e577.patch?full_index=1"
      sha256 "7dafc9e5642f8c1f316ac9dedbc0e4becf198b582b255b53bdf45b8de84bf6b6"
    end
  end
  bottle do
    cellar :any_skip_relocation
    sha256 "b140937d11ed09bd9d57ea4d956c23765365bb72134aaeeb018bb905c73b668f" => :mojave
    sha256 "feec334349faf7eecdea9526a90c9504db8cc5e3488a71deb50c6aa0c31af2f5" => :high_sierra
    sha256 "d0241bbd6538c79b56d67ba986f527df1bf0afa844121b13d1fe2a5120f01192" => :sierra
    sha256 "c413f4e02ff6b4de101a330c619816dd16ae898a02d69a9c85eb60884045f898" => :el_capitan
    sha256 "dbd0957d4593c54d62046d3f4546a0a3bfbd3b00ee254011dc5a7051eafa0945" => :yosemite
  end

  option "with-compat-symlinks",
    "Symlink older names of the tools to the current ones on installation"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
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
