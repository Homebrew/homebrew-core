class Bzip2 < Formula
  desc "Freely available high-quality data compressor"
  homepage "https://sourceware.org/bzip2/"
  url "https://sourceware.org/pub/bzip2/bzip2-1.0.8.tar.gz"
  sha256 "ab5a03176ee106d3f0fa90e381da478ddae405918153cca248e682cd0c4a2269"
  license "bzip2-1.0.6"

  livecheck do
    url "https://sourceware.org/pub/bzip2/"
    regex(/href=.*?bzip2[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27e9523dea4a8710c6df73e27014ce70346217d27ae83d326a728404052f9eea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "34bcbd41ffc141ea961a31b2109637a18628768a4af1856b9ecb3f80fed587b7"
    sha256 cellar: :any_skip_relocation, monterey:       "f693e5af4c3c047ab128edc653920ae135b9e981eadb6a11f9e0e74eebd4914d"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3809e379c13b3af3e18e3533f54e7bdee1c630cfce6143816be859321afa020"
    sha256 cellar: :any_skip_relocation, catalina:       "78421d5891328cb96cce8ff6a6c20ce5930a4a74fd1b24b05ef02cd92117c5fd"
    sha256 cellar: :any_skip_relocation, mojave:         "313e48f4528c1d8042a9cd4c77bd69047dedd7eda2bd350650a902e1ff549a38"
    sha256 cellar: :any_skip_relocation, high_sierra:    "a3eedbcb61a66d3a1286685db878e19c1de90605626d1d988705f66a5aa66673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9e18abf0be3de0f15101a7411aa05a65807b0f9c8f68d634b91e36b42570087"
  end

  keg_only :provided_by_macos

  def install
    inreplace "Makefile", "$(PREFIX)/man", "$(PREFIX)/share/man"

    system "make", "install", "PREFIX=#{prefix}"

    if OS.linux?
      # Install shared libraries
      system "make", "-f", "Makefile-libbz2_so", "clean"
      system "make", "-f", "Makefile-libbz2_so"
      lib.install "libbz2.so.#{version}", "libbz2.so.#{version.major_minor}"
      lib.install_symlink "libbz2.so.#{version}" => "libbz2.so.#{version.major}"
      lib.install_symlink "libbz2.so.#{version}" => "libbz2.so"
    end
  end

  test do
    testfilepath = testpath + "sample_in.txt"
    zipfilepath = testpath + "sample_in.txt.bz2"

    testfilepath.write "TEST CONTENT"

    system "#{bin}/bzip2", testfilepath
    system "#{bin}/bunzip2", zipfilepath

    assert_equal "TEST CONTENT", testfilepath.read
  end
end
