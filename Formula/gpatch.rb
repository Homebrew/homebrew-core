class Gpatch < Formula
  desc "Apply a diff file to an original"
  homepage "https://savannah.gnu.org/projects/patch/"
  url "http://ftpmirror.gnu.org/patch/patch-2.7.5.tar.xz"
  mirror "https://ftp.gnu.org/gnu/patch/patch-2.7.5.tar.xz"
  sha256 "fd95153655d6b95567e623843a0e77b81612d502ecf78a489a4aed7867caa299"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "526112f0034e80e4b830d6a4b486073be6ea79743a1f4cb7b96e7564bf9dbae4" => :el_capitan
    sha256 "6de31643dafee3863e42bfff45ad8b128bd45fa02ea46a9a98732ad84e8b59ed" => :yosemite
    sha256 "0eee795f5f3c9d9e33bfcf83a207cea34fa41f4077fe99e0edc3ff894aedad41" => :mavericks
    sha256 "425e53ed3deb72838fbe14c5ce8e079917db629dd502d36c50f0ea028635bcb1" => :x86_64_linux
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    testfile = testpath/"test"
    testfile.write "homebrew\n"
    patch = <<-EOS.undent
      1c1
      < homebrew
      ---
      > hello
    EOS
    pipe_output("#{bin}/patch #{testfile}", patch)
    assert_equal "hello", testfile.read.chomp
  end
end
