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
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "edf7249cfe2f25f697df299831a0cfbd6d4fcf3803b1fcd3cfd7a9767e13e69a"
    sha256 cellar: :any, arm64_sequoia: "898def3c3d5bca3f781362f31e01f7d70126eb9f6ece12187541f121072ba421"
    sha256 cellar: :any, arm64_sonoma:  "d9f1805c678422455ef617d40683f16d3d37c235a0431859eeacde2d9a0c429c"
    sha256 cellar: :any, sonoma:        "df638d411daf2a227a103852f5f1c3c66d13b54b84b88b75e5e3ed9b42832c2e"
    sha256               arm64_linux:   "385727136943caa3327fca656c0a12f8cb4296c9c50fb785725137922fc4ce23"
    sha256               x86_64_linux:  "ce46fdac05876dd811e370285bed2d68c3d88e474a6f6adaf00cba6c102a8b16"
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

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Tell meson to search for brewed zlib before host zlib on Linux.
    # This is not the same variable as setting LD_LIBRARY_PATH!
    ENV.append "LIBRARY_PATH", Formula["zlib-ng-compat"].opt_lib unless OS.mac?

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
