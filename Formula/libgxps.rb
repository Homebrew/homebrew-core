class Libgxps < Formula
  desc "GObject based library for handling and rendering XPS documents"
  homepage "https://wiki.gnome.org/Projects/libgxps"
  url "https://download.gnome.org/sources/libgxps/0.3/libgxps-0.3.2.tar.xz"
  sha256 "6d27867256a35ccf9b69253eb2a88a32baca3b97d5f4ef7f82e3667fa435251c"
  license "LGPL-2.1-or-later"
  revision 2
  head "https://gitlab.gnome.org/GNOME/libgxps.git", branch: "master"

  livecheck do
    url :stable
    regex(/libgxps[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "0f524e3a24c4939c08d93f3f66af34994bd9ec0a5a2c54323baaba2cfbdd8048"
    sha256 cellar: :any, arm64_monterey: "1ace22f9a74c47c9c4a80c6d0f489e3200a3987257641440e14bb0974a6fd89c"
    sha256 cellar: :any, arm64_big_sur:  "56e4ad2dad8df91707bdb77445b2e0c4b020b9f02aaebd6a667e639546ad91eb"
    sha256 cellar: :any, ventura:        "938519d7611202c22f11ed787bda5055ae7420db034caf2c76e27d19943b99e4"
    sha256 cellar: :any, monterey:       "9806279d50f73693dbad71dd0b4c185196584a9187ee5daaae66882d4f9b7682"
    sha256 cellar: :any, big_sur:        "772f8f4ba58385b382de4e88e2f68e706f3a8fd20e1c5a64a33b154bd1112227"
    sha256 cellar: :any, catalina:       "81189357b4d118895c1994c005bb9265a2a77a71e7fd3d386f3f06113abd541b"
    sha256               x86_64_linux:   "c79ca4a9d50d6447a84b532636d8f9e758667e8284bfb485f6384e146bb4d2f0"
  end

  keg_only "it conflicts with `ghostscript`"

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "glib"
  depends_on "jpeg-turbo"
  depends_on "libarchive"
  depends_on "libtiff"
  depends_on "little-cms2"

  uses_from_macos "zip" => :test
  uses_from_macos "zlib"

  def install
    # Tell meson to search for brewed zlib before host zlib on Linux.
    # This is not the same variable as setting LD_LIBRARY_PATH!
    ENV.append "LIBRARY_PATH", Formula["zlib"].opt_lib unless OS.mac?

    system "meson", *std_meson_args, "build", "-Denable-test=false"
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
    system "#{bin}/xpstopdf", (testpath/"test.xps")
  end
end
