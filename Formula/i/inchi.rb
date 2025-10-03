class Inchi < Formula
  desc "IUPAC International Chemical Identifier"
  homepage "https://www.inchi-trust.org/"
  url "https://github.com/IUPAC-InChI/InChI/releases/download/v1.07.3/INCHI-1-SRC.zip"
  sha256 "b42d828b5d645bd60bc43df7e0516215808d92e5a46c28e12b1f4f75dfaae333"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c2ab3b6c1fc1a9753168ee404157c0773dc268416f8ef52f90ff19a799edb168"
    sha256 cellar: :any,                 arm64_sequoia: "e2bb4775d1cf80b33c796a64d26cee00204db264397f07257069b2dd50a503c4"
    sha256 cellar: :any,                 arm64_sonoma:  "ec8c1fd3849b6e0a443dbb825a1bda423a4d57fb31988c5225fd369dafe2555b"
    sha256 cellar: :any,                 arm64_ventura: "17dfc12c8c97191dc5e622a7bf38098d2c7198ba763cf75945ceca662da1c5b1"
    sha256 cellar: :any,                 sonoma:        "9f3d129b9d5e9a0b40789665a003470e5d876a75d4f23a7a8959ce51fcfcbf6e"
    sha256 cellar: :any,                 ventura:       "8b825f53d14319b5bafa6e9d556033da1bd531d6a7410d83e6640a609d89b44e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c830915f64f9b964f200923ea06d4aa3ca7906a6f2b56da01650356c0dc9efbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "16142b1bb7018bd3641a4ed78dc992d489661f65797e1c77c24ddaa0014042b8"
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
