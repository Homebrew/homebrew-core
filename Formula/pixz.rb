class Pixz < Formula
  desc "Parallel, indexed, xz compressor"
  homepage "https://github.com/vasi/pixz"
  url "https://github.com/vasi/pixz/releases/download/v1.0.7/pixz-1.0.7.tar.gz"
  sha256 "d1b6de1c0399e54cbd18321b8091bbffef6d209ec136d4466f398689f62c3b5f"
  license "BSD-2-Clause"
  head "https://github.com/vasi/pixz.git"

  bottle do
    cellar :any
    sha256 "fa271c0bbea97dccf10ae82803746f86ff67bfbd3a3fdc0c9786a6a6afb7f46d" => :catalina
    sha256 "55562f5c1bc151210be9c85db0ecb3c4544a809793ea9330bc3b6d212b394778" => :mojave
    sha256 "6df8ca6e7449ed6b76174ce16f7ed3433ca28afba82776630dbd31bc6a8fac17" => :high_sierra
  end

  depends_on "asciidoc" => :build
  depends_on "docbook" => :build
  depends_on "pkg-config" => :build
  depends_on "libarchive"
  depends_on "xz"

  uses_from_macos "libxslt"

  def install
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libarchive"].opt_lib/"pkgconfig"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "a2x", "--doctype", "manpage", "--format", "manpage", "src/pixz.1.asciidoc"
    man1.install "src/pixz.1"
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    testfile = testpath/"file.txt"
    testfile.write "foo"
    system "#{bin}/pixz", testfile, "#{testpath}/file.xz"
  end
end
