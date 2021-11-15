class Libgxps < Formula
  desc "GObject based library for handling and rendering XPS documents"
  homepage "https://wiki.gnome.org/Projects/libgxps"
  url "https://download.gnome.org/sources/libgxps/0.3/libgxps-0.3.2.tar.xz"
  sha256 "6d27867256a35ccf9b69253eb2a88a32baca3b97d5f4ef7f82e3667fa435251c"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://gitlab.gnome.org/GNOME/libgxps.git"

  livecheck do
    url :stable
    regex(/libgxps[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_monterey: "2e78b1e36e2e6095af5cbf6f86e1d544d3225402474164aa1d667fbeb97a6e91"
    sha256 cellar: :any, arm64_big_sur:  "0243fa2f8e5b1559b417e47e5aea3b6ab8745164f397963c2ac94952c3915324"
    sha256 cellar: :any, monterey:       "acb2b38e9fa9925dc00c2b8497e9e0c98e38a279d81dd3b2ca6946017bff8367"
    sha256 cellar: :any, big_sur:        "6ad3b9179f42d68083b2b8bf54fe2d36433ed45d51e8ee13af392638e1b07174"
    sha256 cellar: :any, catalina:       "52dc9223c583d315cc9b6edd29e696ac4e8dab1fe5d4d452c9ac3f20af185412"
    sha256 cellar: :any, mojave:         "e113e3685b5f6a000d1e23f2bf67cb78e67c5bba58562156d5a78311ee28c05c"
  end

  keg_only "it conflicts with `ghostscript`"

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

    Dir.chdir(testpath) do
      system "/usr/bin/zip", "-qr", (testpath/"test.xps"), "_rels", "Documents", "FixedDocumentSequence.fdseq"
    end
    system "#{bin}/xpstopdf", (testpath/"test.xps")
  end
end
