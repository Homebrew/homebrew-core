class Attr < Formula
  desc "Manipulate filesystem extended attributes"
  homepage "https://savannah.nongnu.org/projects/attr"
  url "https://download.savannah.nongnu.org/releases/attr/attr-2.5.2.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/nongnu/attr/attr-2.5.2.tar.gz"
  sha256 "39bf67452fa41d0948c2197601053f48b3d78a029389734332a6309a680c6c87"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://download.savannah.nongnu.org/releases/attr/"
    regex(/href=.*?attr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_linux:  "6d22ffeb1ac124b47032e96cfc44264b228f3fcabe9746a426e46a5f7db45c3a"
    sha256 x86_64_linux: "80c103ddb53c169071d3995ac74c7e4cca59aeed6bea4e5444eac1026d380528"
  end

  depends_on :linux

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.txt").write("Hello World!\n")
    output = pipe_output("#{bin}/attr -s name test.txt", "", 0)
    assert_match 'Attribute "name" set to a 0 byte value for test.txt', output
    output = shell_output("#{bin}/attr -l test.txt")
    assert_match 'Attribute "name" has a 0 byte value for test.txt', output
  end
end
