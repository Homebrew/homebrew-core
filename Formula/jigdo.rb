# Jigdo is dead upstream. It consists of two components: Jigdo, a GTK+ using GUI,
# which is LONG dead and completely unfunctional, and jigdo-lite, a command-line
# tool that has been on life support and still works. Only build the CLI tool.
class Jigdo < Formula
  desc "Tool to distribute very large files over the internet"
  homepage "https://www.einval.com/~steve/software/jigdo/"
  url "https://www.einval.com/~steve/software/jigdo/download/jigdo-0.8.1.tar.xz"
  sha256 "b1f08c802dd7977d90ea809291eb0a63888b3984cc2bf4c920ecc2a1952683da"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }

  livecheck do
    url "https://www.einval.com/~steve/software/jigdo/download/"
    regex(/href=.*?jigdo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "6b92895930451607520eeff3ea375e903400a47ca928db9787a6c2547b90de02"
    sha256 arm64_big_sur:  "567951eab25efcfe4d9e27243fdf76433cf8bba33933853cbc35ed488c1d67df"
    sha256 monterey:       "71f954c903845a482a955406e508eaedf808da4cb59463a8f1669c8799af3c3b"
    sha256 big_sur:        "e7cc73b1ab506df548bbb52c9efd259bb48ba34918609791bd9d25b80dbcab99"
    sha256 catalina:       "fc399efb9d6d89d0eb26c8d335868e903d785e1dc9632b3312dacb91c9599932"
    sha256 x86_64_linux:   "e32201e532a2fe0d2a2026b31bef95465f9bcb3f34e078341f8fa6efe8447637"
  end

  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "wget"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args,
                          "--disable-x11",
                          "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/jigdo-file -v")
  end
end
