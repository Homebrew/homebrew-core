class Inchi < Formula
  desc "IUPAC International Chemical Identifier"
  homepage "https://www.inchi-trust.org/"
  url "https://github.com/IUPAC-InChI/InChI/archive/refs/tags/v1.07.5.tar.gz"
  sha256 "9a8af985295c47bfaf424ad8386b1597da515589665ec71908dae1bd2b67ac96"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "36ab60238ffc83ddc7aa58a661188e3f9b9754f07230054f1c3790edab2828d2"
    sha256 cellar: :any,                 arm64_sequoia: "b423e478cc6264757fbed783be94a094714413c9d5f5c06362bd48a3ed0c315c"
    sha256 cellar: :any,                 arm64_sonoma:  "f9d1fd60654c8e799a71e0b117d96e55d741a8463fc29174efba38602c5a7cb0"
    sha256 cellar: :any,                 sonoma:        "aeca4d3b690cacc926624780cb29f169800768618eca1391bfff5c17eee538f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e03338ca5b5c1ec627a44ce27fd4951d7aadbc0d879f5820935a7a62ff6d5e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "080691ff983ce9cd7d7953f6b370be348aec2ae51239ceecc16178b122e5504a"
  end

  depends_on "cmake" => :build

  # These used to be part of open-babel
  link_overwrite "include/inchi/inchi_api.h", "lib/libinchi.dylib", "lib/libinchi.so"

  def install
    args = ["-DCMAKE_EXE_LINKER_FLAGS=-Wl,-rpath,#{rpath}"]
    system "cmake", "-S", "INCHI-1-SRC/INCHI_EXE/inchi-1/src", "-B", "build-cli", *std_cmake_args
    system "cmake", "-S", "INCHI-1-SRC/INCHI_API/demos/inchi_main/src", "-B", "build-main", *args, *std_cmake_args
    system "cmake", "--build", "build-cli"
    system "cmake", "--build", "build-main"
    # No CMake install targets available
    bin.install "build-main/bin/inchi_main", "build-cli/bin/inchi-1"
    lib.install "build-main/bin/#{shared_library("libinchi")}"

    # Install the same headers as Debian[^1] and Fedora[^2]. Some are needed by `open-babel`[^3]
    # and `rdkit`[^4].
    #
    # [^1]: https://packages.debian.org/sid/amd64/libinchi-dev/filelist
    # [^2]: https://packages.fedoraproject.org/pkgs/inchi/inchi-devel/fedora-rawhide.html#files
    # [^3]: https://github.com/openbabel/openbabel/blob/master/cmake/modules/FindInchi.cmake
    # [^4]: https://github.com/rdkit/rdkit/blob/master/External/INCHI-API/inchi.cpp
    headers = %w[bcf_s.h ichisize.h inchi_api.h ixa.h]
    (include/"inchi").install headers.map { |header| "INCHI-1-SRC/INCHI_BASE/src/#{header}" }
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
