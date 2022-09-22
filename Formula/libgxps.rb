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
    sha256 cellar: :any, arm64_monterey: "ef4bbc6216124d5e51c73cca76d1c4a4bed7747931b7a519e6e829d20cd7021c"
    sha256 cellar: :any, arm64_big_sur:  "e45ca333cf831e269ac4ed11864da0f09524c87780e9c7f194415505753b6f2a"
    sha256 cellar: :any, monterey:       "7956a71251563f6589ffd7a061a0e53cdfadcf90893220c94b004231640e3860"
    sha256 cellar: :any, big_sur:        "19265edef8bb260d7a1adca6f6044f5ba94558b06d54d751c5f1144deb5b820e"
    sha256 cellar: :any, catalina:       "1b25899eda944421ff3e97ecd872afc97b15f31cd7e651e1eb1ef05959327fa0"
    sha256               x86_64_linux:   "49e69a37f4fd97632211101d926390e1eae26c8a215b73ed22b86b7caebae3c5"
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
