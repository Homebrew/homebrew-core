class Libgxps < Formula
  desc "GObject based library for handling and rendering XPS documents"
  homepage "https://wiki.gnome.org/Projects/libgxps"
  url "https://download.gnome.org/sources/libgxps/0.3/libgxps-0.3.2.tar.xz"
  sha256 "6d27867256a35ccf9b69253eb2a88a32baca3b97d5f4ef7f82e3667fa435251c"
  license "LGPL-2.1-or-later"
  revision 3
  head "https://gitlab.gnome.org/GNOME/libgxps.git", branch: "master"

  livecheck do
    url :stable
    regex(/libgxps[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:    "94a222a265fa022f1dd5bfe13a862e9c318904fe24bc28f7c6115356ae637468"
    sha256 cellar: :any, arm64_sequoia:  "fdca2abeb3cab442e39539689c5faf9c5540fc723f01c0596c11f2943874c45b"
    sha256 cellar: :any, arm64_sonoma:   "0bc7f03e4357779ac617e6750d70daff18da2a7da889387acdfe75891bcfce0e"
    sha256 cellar: :any, arm64_ventura:  "07d90913277ea1e2a74c547c02173058afa2588ede3e9236ff7f334c894a7b6a"
    sha256 cellar: :any, arm64_monterey: "50c2d473739fb423b1145baaf06f7585ee9a64e5021806bff07cb1f772c1f8f1"
    sha256 cellar: :any, arm64_big_sur:  "2dc505d1715d95510c25f98507f755490c8277324cd8b9ef008c5e8f7783488f"
    sha256 cellar: :any, sonoma:         "c97166ce8e20af3056cae52203f19b07b98f702dc2fec8f076f96dfd8bbc2c88"
    sha256 cellar: :any, ventura:        "d23e0dfb5092636567f86a31839a04fc0831253eb73dc0863929c9c71d648be2"
    sha256 cellar: :any, monterey:       "e523554e0a7faa5c8f0a4ff842f4b462d9cb24411d3f855cb4f7e4eaded44fe2"
    sha256 cellar: :any, big_sur:        "187f95bca68a60db5155a911033be4eab80537598f5dd788a3edbbb7303fe5a5"
    sha256               arm64_linux:    "c230ad46a5f67b2e3862f8d76c1a2e8b92fb59815e06d9265704d6940ae8e218"
    sha256               x86_64_linux:   "0fda080a2b1da025e6d6aef7a9e4934fefaabda48cc9c080088e1146cead5558"
  end

  keg_only "it conflicts with `ghostscript`"

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "freetype"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libarchive"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "little-cms2"

  uses_from_macos "zip" => :test
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Tell meson to search for brewed zlib before host zlib on Linux.
    # This is not the same variable as setting LD_LIBRARY_PATH!
    ENV.append "LIBRARY_PATH", Formula["zlib"].opt_lib unless OS.mac?

    system "meson", "setup", "build", "-Denable-test=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  def caveats
    <<~EOS
      `ghostscript` now installs a conflicting #{shared_library("libgxps")}.
      You may need to `brew unlink libgxps` if you have both installed.
    EOS
  end

  test do
    mkdir_p [
      (testpath/"Documents/1/Pages/_rels/"),
      (testpath/"_rels/"),
    ]

    (testpath/"FixedDocumentSequence.fdseq").write <<~EOS
      <FixedDocumentSequence>
      <DocumentReference Source="/Documents/1/FixedDocument.fdoc"/>
      </FixedDocumentSequence>
    EOS
    (testpath/"Documents/1/FixedDocument.fdoc").write <<~EOS
      <FixedDocument>
      <PageContent Source="/Documents/1/Pages/1.fpage"/>
      </FixedDocument>
    EOS
    (testpath/"Documents/1/Pages/1.fpage").write <<~EOS
      <FixedPage Width="1" Height="1" xml:lang="und" />
    EOS
    (testpath/"_rels/.rels").write <<~EOS
      <Relationships>
      <Relationship Target="/FixedDocumentSequence.fdseq" Type="http://schemas.microsoft.com/xps/2005/06/fixedrepresentation"/>
      </Relationships>
    EOS
    [
      "_rels/FixedDocumentSequence.fdseq.rels",
      "Documents/1/_rels/FixedDocument.fdoc.rels",
      "Documents/1/Pages/_rels/1.fpage.rels",
    ].each do |f|
      (testpath/f).write <<~EOS
        <Relationships />
      EOS
    end

    zip = OS.mac? ? "/usr/bin/zip" : Formula["zip"].opt_bin/"zip"
    Dir.chdir(testpath) do
      system zip, "-qr", (testpath/"test.xps"), "_rels", "Documents", "FixedDocumentSequence.fdseq"
    end
    system bin/"xpstopdf", (testpath/"test.xps")
  end
end
