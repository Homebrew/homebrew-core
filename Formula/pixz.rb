class Pixz < Formula
  desc "Parallel, indexed, xz compressor"
  homepage "https://github.com/vasi/pixz"
  url "https://github.com/vasi/pixz/releases/download/v1.0.6/pixz-1.0.6.tar.gz"
  sha256 "c54a406dddc6c2226779aeb4b5d5b5649c1d3787b39794fbae218f7535a1af63"

  head "https://github.com/vasi/pixz.git"

  bottle do
    cellar :any
    sha256 "10381873315179d3bf741657a09589b8fec8347d948e604b64e1cac430ad86d1" => :sierra
    sha256 "5e9e759698f203e6cc9cc369014bb86236ae83135f66659faaf8e024c727a5b4" => :el_capitan
    sha256 "f3409a92f9943e02c500d52b552810b6c75132288c969f2aff58d0c93dd4ceca" => :yosemite
    sha256 "8a7d9c9017d273bb234520e560893bff827e0e43d7b83fde9783031d46b0b0f3" => :mavericks
  end

  option "with-docs", "Build man pages using asciidoc and DocBook"

  depends_on "pkg-config" => :build
  depends_on "libarchive"
  depends_on "xz"

  if build.with? "docs"
    depends_on "asciidoc" => :build
    depends_on "docbook" => :build
  end

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libarchive"].opt_lib/"pkgconfig"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    if build.with? "docs"
      ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
      system "a2x", "--doctype", "manpage", "--format", "manpage", "src/pixz.1.asciidoc"
      man1.install "src/pixz.1"
    end
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    testfile = testpath/"file.txt"
    testfile.write "foo"
    system "#{bin}/pixz", testfile, "#{testpath}/file.xz"
  end
end
