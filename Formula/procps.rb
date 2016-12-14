class Procps < Formula
  desc "Utilities for browsing procfs"
  homepage "https://gitlab.com/procps-ng/procps"
  url "https://gitlab.com/procps-ng/procps/repository/archive.tar.gz?ref=v3.3.11"
  sha256 "69e421cb07d5dfd38100b4b68714e9cb05d4fe58a7c5145c7b672d1ff08ca58b"
  head "https://gitlab.com/procps-ng/procps.git"
  # tag "linuxbrew"

  bottle do
    sha256 "96622dce78d108700b6a7b55c745eba71f923da26ed8d7466eb6109b02234c62" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gettext" => :build

  def install
    system "./autogen.sh"
    system "./configure",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}"
    system "make", "install"

    # kill and uptime are also provided by coreutils
    rm [bin/"kill", bin/"uptime", man1/"kill.1", man1/"uptime.1"]
  end

  test do
    system "#{bin}/ps", "--version"
    system "#{bin}/ps"
  end
end
