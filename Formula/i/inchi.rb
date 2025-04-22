class Inchi < Formula
  desc "IUPAC International Chemical Identifier"
  homepage "https://www.inchi-trust.org/"
  url "https://github.com/IUPAC-InChI/InChI/releases/download/v1.07.3/INCHI-1-SRC.zip"
  sha256 "b42d828b5d645bd60bc43df7e0516215808d92e5a46c28e12b1f4f75dfaae333"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f8c679765ab69cc6aae5b2fa81f6bbeea4c903826060410d0b36f4794211f005"
    sha256 cellar: :any,                 arm64_sonoma:  "b7fc7a880952735827136cd6ef79d7d624b5543faaa6bc2223f4ebbf63c3f111"
    sha256 cellar: :any,                 arm64_ventura: "21ecf31cb3a08690a8f126b4de6b1c6763555e1d976951c36fad7adbf8e30a6f"
    sha256 cellar: :any,                 sonoma:        "3db52eb01148b9f7bd51984b0f3a74bd094df492135d7aee961a593df7c052a8"
    sha256 cellar: :any,                 ventura:       "2cdfe8cc8a2577264d50d5b3f577d12fd2f75781bcfc7e020e0579b1383a20c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f11430d8f96d6a69e1f8604bc297108ea4e7871c4209b0a02cf7c0da382f07a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4154598d70aa3ff9644319a6f181b3044748779833d3d1d7544005ce1162268"
  end

  # These used to be part of open-babel
  link_overwrite "include/inchi/inchi_api.h", "lib/libinchi.dylib", "lib/libinchi.so"

  def install
    bin.mkpath
    lib.mkpath

    args = ["C_COMPILER=#{ENV.cc}", "BIN_DIR=#{bin}", "LIB_DIR=#{lib}"]
    system "make", "-C", "INCHI_API/libinchi/gcc", *args
    system "make", "-C", "INCHI_EXE/inchi-1/gcc", *args

    # Add major versioned and unversioned symlinks
    libinchi = shared_library("libinchi", version.to_s[/^(\d+\.\d+)/, 1])
    odie "Unable to find #{libinchi}" unless (lib/libinchi).exist?
    lib.install_symlink libinchi => shared_library("libinchi", version.major.to_s)
    lib.install_symlink shared_library("libinchi", version.major.to_s) => shared_library("libinchi")

    # Install the same headers as Debian[^1] and Fedora[^2]. Some are needed by `open-babel`[^3].
    #
    # [^1]: https://packages.debian.org/sid/amd64/libinchi-dev/filelist
    # [^2]: https://packages.fedoraproject.org/pkgs/inchi/inchi-devel/fedora-rawhide.html#files
    # [^3]: https://github.com/openbabel/openbabel/blob/master/cmake/modules/FindInchi.cmake
    (include/"inchi").install %w[ichisize.h inchi_api.h ixa.h].map { |header| "INCHI_BASE/src/#{header}" }
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
