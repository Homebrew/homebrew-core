class Libredwg < Formula
  desc "DWG utilities"
  homepage "https://www.gnu.org/software/libredwg/"
  url "https://ftpmirror.gnu.org/gnu/libredwg/libredwg-0.13.3.tar.gz"
  sha256 "6fe6c273ecbb04d4a7646e1636ede4815b51f98f974cece649dab341d24feda2"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ea51df25eb164d61d115e33461234251acbe0ced0784963fc84f55bec57b34bd"
    sha256 cellar: :any, arm64_sequoia: "d8e11e10c4e625f92933ce9c7cf8432a7c5b45aff046f8e811b6b222da3224ac"
    sha256 cellar: :any, arm64_sonoma:  "3e3dafb61bd8d68123bf43f769aebf263ccb43364d15f2fd5b8d0d331248841a"
    sha256 cellar: :any, sonoma:        "fb9bd68e4b4f9c60d4cb14dadbe7073539554a1240ae8303dfd23cfe3c0818a8"
    sha256 cellar: :any, arm64_linux:   "edc880d653416402b35f89eb5163d211b1dd190d0eb97b24754fc0a0cb89e126"
    sha256 cellar: :any, x86_64_linux:  "a50bee6cf0823f13b87aec30d0c662dc6be4b636b68e3b47d1c91ad50893ddf7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "texinfo" => :build

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    resource "testdata" do
      url "https://github.com/LibreDWG/libredwg/raw/refs/heads/master/test/test-data/example_2000.dwg"
      sha256 "34574244d7556d1ef7b437443d9b3d1ad8662e1c669c42d80cff6a8a19799be9"
    end

    resource("testdata").stage do
      system bin/"dwgread", "-o", "example_2000.dxf", "example_2000.dwg"
      assert_path_exists "example_2000.dxf"
    end
  end
end
