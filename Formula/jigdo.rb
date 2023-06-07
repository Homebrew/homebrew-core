class Jigdo < Formula
  desc "Tool to distribute very large files over the internet"
  homepage "https://www.einval.com/~steve/software/jigdo/"
  url "https://www.einval.com/~steve/software/jigdo/download/jigdo-0.8.1.tar.xz"
  sha256 "b1f08c802dd7977d90ea809291eb0a63888b3984cc2bf4c920ecc2a1952683da"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  head "https://git.einval.com/git/jigdo.git", branch: "upstream"

  livecheck do
    url "https://www.einval.com/~steve/software/jigdo/download/"
    regex(/href=.*?jigdo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "7f40b31d3cbf93164a64189389a044f453c780696768bfc8003b8ab991dbcbce"
    sha256 arm64_monterey: "6e9590cc36dc2f0f3d75d565a1c5f99582c25ee41297d8ef67b04480c56e4bf5"
    sha256 arm64_big_sur:  "2a751d087e93881f023139a101fc21e7c9ee3d54fa24d0b210d64128271b3ad0"
    sha256 ventura:        "0b5a19248f88195a2c8b260d2c6645b2b9036f70de0270079b596c640bc982f7"
    sha256 monterey:       "500f02c729d51da1d7e1515111efc02adf900638c70980cfdadcd693f9c41726"
    sha256 big_sur:        "f57af0993dfde16f88d148b15f22fae331798b82a518515d9b8f4e53f93aabe8"
    sha256 x86_64_linux:   "132117193141114c71df0b3f4c0c193c754b9b70865190237b65424c79b30f50"
  end

  depends_on "pkg-config" => :build
  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "wget"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "gettext" => :build # for msgfmt
  end

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "./configure", *std_configure_args, "--mandir=#{man}"

    # replace non-existing function
    inreplace "src/compat.hh", "return truncate64(path, length);", "return truncate(path, length);" if OS.mac?

    # disable documentation building
    (buildpath/"doc/Makefile").atomic_write "all:\n\techo hello"

    # disable documentation installing
    inreplace "Makefile", "$(INSTALL) \"$$x\" $(DESTDIR)$(mandir)/man1", "echo \"$$x\""

    system "make"
    system "make", "install"
  end

  test do
    system bin/"jigdo-file", "make-template", "--image=#{test_fixtures("test.png")}",
                                              "--template=#{testpath}/template.tmp",
                                              "--jigdo=#{testpath}/test.jigdo"

    assert_path_exists testpath/"test.jigdo"
    assert_path_exists testpath/"template.tmp"
    system bin/"jigdo-file", "make-image", "--image=#{testpath/"test.png"}",
                                           "--template=#{testpath}/template.tmp",
                                           "--jigdo=#{testpath}/test.jigdo"
    system bin/"jigdo-file", "verify", "--image=#{testpath/"test.png"}",
                                       "--template=#{testpath}/template.tmp"
  end
end
