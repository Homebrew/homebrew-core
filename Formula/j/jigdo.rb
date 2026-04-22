class Jigdo < Formula
  desc "Tool to distribute very large files over the internet"
  homepage "https://www.einval.com/~steve/software/jigdo/"
  url "https://www.einval.com/~steve/software/jigdo/download/jigdo-0.8.2.tar.xz"
  sha256 "36f286d93fa6b6bf7885f4899c997894d21da3a62176592ac162d9c6a8644f9e"
  license "GPL-2.0-only" => { with: "openvpn-openssl-exception" }
  head "https://git.einval.com/git/jigdo.git", branch: "master"

  livecheck do
    url "https://www.einval.com/~steve/software/jigdo/download/"
    regex(/href=.*?jigdo[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "e8dc3605b3abe08d1608a08a2c30309226c58b6497848e43ba3332ecc2d463f7"
    sha256 arm64_sequoia: "14b9065aa6b5f05bcf7328f85b854a9113ed0ddc3ebb7a704c349d846901cc6a"
    sha256 arm64_sonoma:  "cdff3664d745bb5b732981366d4781ac9aecc51d3c976e3426cdd7197f7a3ca2"
    sha256 sonoma:        "a8a6118725052ad1d8c9b861c81aa2353334a40ca569eb81e6ad5a7c5dcd6d04"
    sha256 arm64_linux:   "8afdb208a290a24a4ac92a58fc25a131fef91d95dd097e73094b7466cef39445"
    sha256 x86_64_linux:  "0951aa918b28011dec191e3690a024dc14ce93c63112732482d07dabe7c92c06"
  end

  depends_on "gettext" => :build # for msgfmt
  depends_on "pkgconf" => :build
  depends_on "berkeley-db@5" # keep berkeley-db < 6 to avoid AGPL incompatibility
  depends_on "wget"

  uses_from_macos "bzip2"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Find our docbook catalog
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"
    system "./configure", "--mandir=#{man}", *std_configure_args

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
