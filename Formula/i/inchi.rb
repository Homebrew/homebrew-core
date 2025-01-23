class Inchi < Formula
  desc "IUPAC International Chemical Identifier"
  homepage "https://www.inchi-trust.org/"
  url "https://github.com/IUPAC-InChI/InChI/releases/download/v1.07.2/INCHI-1-SRC.zip"
  sha256 "4a5627befd1ea29853d4920d975563874108648efe9bfcd1d4dfa3a215032cfb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "25f7aebdb481a803f18fa0627ec514de1005582706ca16e4df152721f5a073e2"
    sha256 cellar: :any,                 arm64_sonoma:  "7473f6e96cc89bd4afe24c8de25e113bb413b7a87aae10e401d30b90fc7f7e33"
    sha256 cellar: :any,                 arm64_ventura: "32c4b33b8814920aa956f7ba12ba4910846d46a25ce2ce97c56c62c689166021"
    sha256 cellar: :any,                 sonoma:        "d88925c6975be8a0e19f5519ddd9d4891c72ce8e6440b3dd047627f990c64144"
    sha256 cellar: :any,                 ventura:       "3a672451ca7f22d991068b6832cf1183b35a91250c27a945f5b3810c02476c52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6aa1570cbbc5be0acc8e6fb4dada9e301b2bd9d45c430ba558306fae993f8aba"
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
