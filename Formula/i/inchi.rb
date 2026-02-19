class Inchi < Formula
  desc "IUPAC International Chemical Identifier"
  homepage "https://www.inchi-trust.org/"
  url "https://github.com/IUPAC-InChI/InChI/releases/download/v1.07.4/INCHI-1-SRC.zip"
  sha256 "9228a214a2817aa6508c81803b656333531bb86d2c37c8a4916c2883cb88b2ad"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c4e58edd54851bab4ff3ee9281a11dfb07f32874118e595b6bd026de85d6ef8d"
    sha256 cellar: :any,                 arm64_sequoia: "60b1d27d2cddb718a3821199a70d517663ce34fa76b6325afdf8ba43bbc4a880"
    sha256 cellar: :any,                 arm64_sonoma:  "7b4d93bbaccc17ae6456a06ad4cfc052157476e9a66e82a0a872eddbbd537593"
    sha256 cellar: :any,                 sonoma:        "61cfaea70f0fb94e90160d0f5aad68af49265fed492f2a6797a154d7fde4d286"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "77227fd2f62a240045efecf527760cff9e44bf703bbc51835990df1333c33e6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3053b57f288336c1124ba2ab89a26f8486499b4bf865dc9602d972a21d66481"
  end

  # These used to be part of open-babel
  link_overwrite "include/inchi/inchi_api.h", "lib/libinchi.dylib", "lib/libinchi.so"

  def install
    bin.mkpath
    lib.mkpath

    args = ["C_COMPILER=#{ENV.cc}", "BIN_DIR=#{bin}", "LIB_DIR=#{lib}"]
    system "make", "-C", "INCHI_API/libinchi/gcc", *args
    system "make", "-C", "INCHI_EXE/inchi-1/gcc", *args

    # Install the same headers as Debian[^1] and Fedora[^2]. Some are needed by `open-babel`[^3]
    # and `rdkit`[^4].
    #
    # [^1]: https://packages.debian.org/sid/amd64/libinchi-dev/filelist
    # [^2]: https://packages.fedoraproject.org/pkgs/inchi/inchi-devel/fedora-rawhide.html#files
    # [^3]: https://github.com/openbabel/openbabel/blob/master/cmake/modules/FindInchi.cmake
    # [^4]: https://github.com/rdkit/rdkit/blob/master/External/INCHI-API/inchi.cpp
    (include/"inchi").install %w[bcf_s.h ichisize.h inchi_api.h ixa.h].map { |header| "INCHI_BASE/src/#{header}" }
  end

  test do
    # https://github.com/openbabel/openbabel/blob/master/test/files/alanine.mol
    (testpath/"alanine.mol").write <<~EOS

        Ketcher 02131813502D 1   1.00000     0.00000     0

        7  6  0     0  0            999 V2000
          1.0000    1.0000    0.0000 N   0  0  0  0  0  0  0  0  0  0  0  0
          1.0000    2.0000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          1.8660    2.5000    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          0.5000    2.8660    0.0000 C   0  0  0  0  0  0  0  0  0  0  0  0
          2.7321    2.0000    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0
          1.8660    3.5000    0.0000 O   0  0  0  0  0  0  0  0  0  0  0  0
          0.0000    2.0000    0.0000 H   0  0  0  0  0  0  0  0  0  0  0  0
        1  2  1  0     0  0
        2  3  1  0     0  0
        2  4  1  1     0  0
        3  5  1  0     0  0
        3  6  2  0     0  0
        2  7  1  6     0  0
      M  END
      $$$$
    EOS

    assert_equal <<~EOS, shell_output("#{bin}/inchi-1 alanine.mol -STDIO")
      Structure: 1
      InChI=1S/C3H7NO2/c1-2(4)3(5)6/h2H,4H2,1H3,(H,5,6)/t2-/m0/s1
      AuxInfo=1/1/N:4,2,3,1,5,6/E:(5,6)/it:im/rA:7nNCCCOOH/rB:s1;s2;P2;s3;d3;N2;/rC:1,1,0;1,2,0;1.866,2.5,0;.5,2.866,0;2.7321,2,0;1.866,3.5,0;0,2,0;
    EOS
  end
end
