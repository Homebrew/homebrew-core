class Pixz < Formula
  desc "Parallel, indexed, xz compressor"
  homepage "https://github.com/vasi/pixz"
  url "https://github.com/vasi/pixz/releases/download/v1.0.7/pixz-1.0.7.tar.gz"
  sha256 "d1b6de1c0399e54cbd18321b8091bbffef6d209ec136d4466f398689f62c3b5f"
  license "BSD-2-Clause"
  head "https://github.com/vasi/pixz.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "cbac7ec94ed46a7254753b6f7766a406d806ec5a7312cad5bc10b625bd8a0258"
    sha256 cellar: :any,                 arm64_big_sur:  "ad1f4bab403a28e5828c010167bfe1f70eebbc1ef28385e1079115b5460ed40a"
    sha256 cellar: :any,                 monterey:       "50952f639f6b96f3b1331d1d8bb89861a55733ed93ccd6342f67ea1164f8ca94"
    sha256 cellar: :any,                 big_sur:        "5952ff127c4ffd61ec9196cc556e9b3e0a60c2edc35663c078e8eb556d7652a0"
    sha256 cellar: :any,                 catalina:       "fa271c0bbea97dccf10ae82803746f86ff67bfbd3a3fdc0c9786a6a6afb7f46d"
    sha256 cellar: :any,                 mojave:         "55562f5c1bc151210be9c85db0ecb3c4544a809793ea9330bc3b6d212b394778"
    sha256 cellar: :any,                 high_sierra:    "6df8ca6e7449ed6b76174ce16f7ed3433ca28afba82776630dbd31bc6a8fac17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "030cf6a885eb038a1ce457514d76120aade5bc22efec5452c1c82c85b0557d37"
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
