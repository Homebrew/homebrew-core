class Cmix < Formula
  desc "Data compression program with high compression ratio"
  homepage "https://www.byronknoll.com/cmix.html"
  url "https://github.com/byronknoll/cmix/archive/v18.tar.gz"
  version "18.0.0"
  sha256 "2f0272186a8ff693146d0d8070ad4d9687461a486805ab91d727891df316498d"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, ventura:      "0e7c677e5c3b587dc81178d363b9a1210ad52daaf903a248d1c77d4e589a6c3b"
    sha256 cellar: :any_skip_relocation, monterey:     "ad293329e67ffa22e3e159643c1324b587096c27daf0f0b77feb3633f3adf0c3"
    sha256 cellar: :any_skip_relocation, big_sur:      "3ab169d97ef3e781f7fab12bcf99a74a584462fa154e59d85f96449aa525077c"
    sha256 cellar: :any_skip_relocation, catalina:     "9dbbd3e8367f799405fbb237d68fe46e968bda502a5779f3be1c467b56e394b8"
    sha256 cellar: :any_skip_relocation, mojave:       "448fa06555b59d6a0541d1e36ff9eac14e05775fd2ef119e860a305368b800ec"
    sha256 cellar: :any_skip_relocation, high_sierra:  "6e1bc1de5f3c36e6fcda7874b8fbd18938aedbdbce94039763302f9643964a0a"
    sha256 cellar: :any_skip_relocation, sierra:       "3dc97bda2656e2b2ffccb50915f9a981513fff5a8f90af2a1c5521afe52568d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ced902c9d32516366f0135dfa397ede6068c5c6434db5db16b1fcd7cb0a6a069"
  end

  depends_on arch: :x86_64 # https://github.com/byronknoll/cmix/issues/51

  def install
    system "make"
    bin.install "cmix"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/cmix", "-c", "foo", "foo.cmix"
    system "#{bin}/cmix", "-d", "foo.cmix", "foo.unpacked"
    assert_equal "test", shell_output("cat foo.unpacked")
  end
end
