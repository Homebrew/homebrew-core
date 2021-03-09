class Libgxps < Formula
  desc "GObject based library for handling and rendering XPS documents"
  homepage "https://wiki.gnome.org/Projects/libgxps"
  url "https://download.gnome.org/sources/libgxps/0.3/libgxps-0.3.2.tar.xz"
  sha256 "6d27867256a35ccf9b69253eb2a88a32baca3b97d5f4ef7f82e3667fa435251c"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/libgxps[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "22c593c1dafcc8a09e55ba9fc2c376b404d0fb0b62f800065f0f6edf047bb2fa"
    sha256 cellar: :any, big_sur:       "c5f3520c5a94f6e33ff52a745c1d1667440ef8d662948f16ad25e82155ac4c8d"
    sha256 cellar: :any, catalina:      "994ff26d92b50c014da31562fadace384a425c61d42037e8a03c2fa8f3b6a27a"
    sha256 cellar: :any, mojave:        "b1d3ce677599e912000eae265d671a8e38f21daefadcb0dd23845b8130665295"
  end

  head do
    url "https://gitlab.gnome.org/GNOME/libgxps.git"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gtk+3"
  depends_on "libarchive"
  depends_on "little-cms2"

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
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

    Dir.chdir(testpath) do
      system "/usr/bin/zip", "-qr", (testpath/"test.xps"), "_rels", "Documents", "FixedDocumentSequence.fdseq"
    end
    system "#{bin}/xpstopdf", (testpath/"test.xps")
  end
end
