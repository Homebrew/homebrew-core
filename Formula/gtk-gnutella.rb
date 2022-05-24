class GtkGnutella < Formula
  desc "Share files in a peer-to-peer (P2P) network"
  homepage "https://gtk-gnutella.sourceforge.io"
  url "https://downloads.sourceforge.net/project/gtk-gnutella/gtk-gnutella/1.2.2/gtk-gnutella-1.2.2.tar.xz"
  sha256 "95a5d86878f6599df649b95db126bd72b9e0cecadb96f41acf8fdcc619771eb6"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_monterey: "dfc1a6e5ea48981b08e4ec2a74dbf2e60204c0577ebd42512252dfd465dfb312"
    sha256 arm64_big_sur:  "e6569a85d4d46b2583050ab09c1716ebabef593d560c07808e9530a629b5db79"
    sha256 monterey:       "50e16867768e56729aa34a8a8b96a103652b056c508744542cf1108d11a9937c"
    sha256 big_sur:        "92c2fcc1744502b5b1baf63ad167e70414c0434ad2d7aaf6598bfd2625ed8c5f"
    sha256 catalina:       "78151f5c823fce4c91ec7fec4cd8845c420117b558f3664c38846172a05b6129"
    sha256 x86_64_linux:   "801d4b14d9fe1195d465389d0281a1b3812f77bc116cb322f5213a5b87e7df77"
  end

  depends_on "pkg-config" => :build
  depends_on "gtk+"

  def install
    ENV.deparallelize

    if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"
      inreplace "Configure", "ret = clock_gettime(CLOCK_REALTIME, &tp);",
                             "ret = undefinedgibberish(CLOCK_REALTIME, &tp);"
    end

    system "./build.sh", "--prefix=#{prefix}", "--disable-nls"
    system "make", "install"
    rm_rf share/"pixmaps"
    rm_rf share/"applications"
  end

  test do
    system "#{bin}/gtk-gnutella", "--version"
  end
end
