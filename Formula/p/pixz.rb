class Pixz < Formula
  desc "Parallel, indexed, xz compressor"
  homepage "https://github.com/vasi/pixz"
  url "https://github.com/vasi/pixz/releases/download/v1.0.7/pixz-1.0.7.tar.gz"
  sha256 "d1b6de1c0399e54cbd18321b8091bbffef6d209ec136d4466f398689f62c3b5f"
  license "BSD-2-Clause"
  head "https://github.com/vasi/pixz.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "b760a3d166ab9febb997a2e8b0b295fbbc8d5d4b50ecbc068a38e61a09ba5977"
    sha256 cellar: :any,                 arm64_sequoia:  "a92eaf0c89c34b5db225090adeedd24d26e3481d46e43eca1e94a2fdd509a98a"
    sha256 cellar: :any,                 arm64_sonoma:   "b563d62f32ca6b6382d1ed936be2bde9d83259081ff18b709ef4537d3aaa83b5"
    sha256 cellar: :any,                 arm64_ventura:  "8b8196d1d48f4104e40bd0963e7ffa5eca16e4499b746802fb55ff528e2fad25"
    sha256 cellar: :any,                 arm64_monterey: "c4b1e3fe61fa37f1e6854d8adc032e18d16093b17060a97cd81f421bf9b1c9fc"
    sha256 cellar: :any,                 arm64_big_sur:  "7a61cbb0485e22375ce03a81089da37f34aac406a14447856e7f81b7240a1b86"
    sha256 cellar: :any,                 sonoma:         "b584017019900bd6e4e8d1040b74b54095c2d17e3ade4b08dbd963a03ce44917"
    sha256 cellar: :any,                 ventura:        "b76e0ef617047c5db1d634e87630904018c01d89468576c50fced29b08887f85"
    sha256 cellar: :any,                 monterey:       "e106250f6eee640ca6061f55ff2339539c2047325d878478bd7e5c5acf354d08"
    sha256 cellar: :any,                 big_sur:        "088fd95bfc5540586369b0adb35f6f37009b1f30d4b29de58342828202b8317e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "87cb676de2f355d9918910e4649f45f4a1b1b474cb91479bc21ad19c0bddf2c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a110294724b79c7a130b3705c91d25fa52e01f7cf6655d486a0901ada6d6b24"
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "pkgconf" => :build
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
    system bin/"pixz", testfile, "#{testpath}/file.xz"
  end
end
