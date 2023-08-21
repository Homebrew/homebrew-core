class Admesh < Formula
  desc "Processes triangulated solid meshes"
  homepage "https://github.com/admesh/admesh"
  url "https://github.com/admesh/admesh/releases/download/v0.98.5/admesh-0.98.5.tar.gz"
  sha256 "0d7994bfa587c4e958b2ac7c7d2fb90dfb6c5463d32513ada169cf710a438535"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "574b1956bd94a641fac2f06a85f9cfe3aaf5969a14ec3d88a5431230cbd36e49"
    sha256 cellar: :any,                 arm64_monterey: "3c0ddb99e13c88ae4197e0822e1bb616f1c681f38a907da42099f0bcb763f3a7"
    sha256 cellar: :any,                 arm64_big_sur:  "7fc9a0d3002aa670461964731d21e8e32e080dd6447c6bac9f0bd13a23074040"
    sha256 cellar: :any,                 ventura:        "45c04648928137181b483df0a17cef9b5d254e6f49d089861436930bed9f6a1a"
    sha256 cellar: :any,                 monterey:       "d2741e200d97e2528ea4e5d2449ae474a793218891db0bdd568d7bca314f0149"
    sha256 cellar: :any,                 big_sur:        "b9f6d7b1b242abeb35ce180f190f56acdbb10b547bc3f90a07b0c380bde3727f"
    sha256 cellar: :any,                 catalina:       "d741e030b9ae1a2022dad2e17a2e98dc6516bae9df607fb3841d6397317b8e83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d06691e618a708b7c30459acdc5e70f2abed11d5a2f8c7622b1fc6f8ef353f8"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Test file is the beginning of block.stl from admesh's source
    (testpath/"test.stl").write <<~EOS
      SOLID Untitled1
      FACET NORMAL  0.00000000E+00  0.00000000E+00  1.00000000E+00
      OUTER LOOP
      VERTEX -1.96850394E+00  1.96850394E+00  1.96850394E+00
      VERTEX -1.96850394E+00 -1.96850394E+00  1.96850394E+00
      VERTEX  1.96850394E+00 -1.96850394E+00  1.96850394E+00
      ENDLOOP
      ENDFACET
      ENDSOLID Untitled1
    EOS
    system "#{bin}/admesh", "test.stl"
  end
end
