class Libftdi < Formula
  desc "Library to talk to FTDI chips"
  homepage "https://www.intra2net.com/en/developer/libftdi"
  url "https://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.5.tar.bz2"
  sha256 "7c7091e9c86196148bd41177b4590dccb1510bfe6cea5bf7407ff194482eb049"
  license "LGPL-2.1-only"
  revision 2

  livecheck do
    url "https://www.intra2net.com/en/developer/libftdi/download.php"
    regex(/href=.*?libftdi1[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "09132f1d347fe01a17da39c406e4311ad5af9609c5306afdfe912132df89f74f"
    sha256 cellar: :any,                 arm64_sequoia:  "c53870c2c84cf0918cbf27dfa0f62b3dc331072846980ef86243f506e1752f7a"
    sha256 cellar: :any,                 arm64_sonoma:   "63ffb0285cabb32fb40e7f609ba8e63da9c0452e30400bd9261218bd3e393b9f"
    sha256 cellar: :any,                 arm64_ventura:  "db8777d9eec5f36b23b191183c6d25c398484c09b2ca5833d5ef252ef5ce7bfd"
    sha256 cellar: :any,                 arm64_monterey: "00a1cf52f2dd6bc539fe5dc2cd2aa539722b285e37c0969e5e9b0e98e14f35c5"
    sha256 cellar: :any,                 arm64_big_sur:  "998ea9ac5c02fdad06ad304dc36ccd0b010267271e7d68ff3f3cfbf407339067"
    sha256 cellar: :any,                 sonoma:         "e558ddf5285fce63e1b722341f646989c095481c19f780c915041d65b58b1e14"
    sha256 cellar: :any,                 ventura:        "47d6bbb7af7b2e03dec5f2facae51a32650aac428628af0d5d8e393d48663fc8"
    sha256 cellar: :any,                 monterey:       "a51e714c8f9c12fabd316d643927d09458535aeff83e97a00cdbdeddedfc0962"
    sha256 cellar: :any,                 big_sur:        "26dfaad8173c39d9aa57354256ae4885ea4154a5c3f539c0cb8929e627cafd72"
    sha256 cellar: :any,                 catalina:       "8f20fb63150135151bac6d385c5c8fac07ccdc97c5d4a17d1d9aaf62737a606c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "f46b81927052090bf7c2c756414545f1af98e48ec10e0bd8a697abb7253a72ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cd40f6f49dc081c4cc7e3ea4b159b428d1e611dbc708c1d06bcb3c10f1f3fea"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "confuse"
  depends_on "libusb"

  # Patch to fix pkg-config flags issue. Homebrew/homebrew-core#71623
  # http://developer.intra2net.com/git/?p=libftdi;a=commit;h=cdb28383402d248dbc6062f4391b038375c52385
  patch do
    url "http://developer.intra2net.com/git/?p=libftdi;a=patch;h=cdb28383402d248dbc6062f4391b038375c52385;hp=5c2c58e03ea999534e8cb64906c8ae8b15536c30"
    sha256 "db4c3e558e0788db00dcec37929f7da2c4ad684791977445d8516cc3e134a3c4"
  end

  # Backport commits to increase to cmake 3.5 minimum needed by cmake 4
  patch do
    url "http://developer.intra2net.com/git/?p=libftdi;a=patch;h=3861e7dc9e83f2f6ff4e1579cf3bbf63a6827105"
    sha256 "ffe62563c3696f0e251acf2a23718b11e62d625e2e9826ba17fd1e83861775fb"
  end
  patch do
    url "http://developer.intra2net.com/git/?p=libftdi;a=patch;h=3dc444f99bbc780f06ee6115c086e30f2dda471a"
    sha256 "63b9eb4e4c12ea0ee7d314a1d50d38dc025f9433986cacfbbca443e7c2a004b8"
  end
  patch do
    url "http://developer.intra2net.com/git/?p=libftdi;a=patch;h=61a6bac98bbac623fb33b6153a063b6436f84721"
    sha256 "68dc235a70c8b3ea62fa1d498c8b13f290a32affa947119202f8655037bbfe37"
  end
  patch do
    url "http://developer.intra2net.com/git/?p=libftdi;a=patch;h=de9f01ece34d2fe6e842e0250a38f4b16eda2429"
    sha256 "3fe298c7f61a353160c4e1df74a06a4f7ed26e121b3608237b6fe68186208129"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON",
                    "-DCMAKE_CXX_STANDARD=11",
                    "-DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: pkgshare/"examples/bin")}",
                    "-DFTDIPP=ON",
                    "-DPYTHON_BINDINGS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
    (pkgshare/"examples/bin").install buildpath.glob("build/examples/*").select { |f| f.file? && f.executable? }
  end

  test do
    system pkgshare/"examples/bin/find_all"
  end
end
