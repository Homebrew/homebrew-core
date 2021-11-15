class Libnet < Formula
  desc "C library for creating IP packets"
  homepage "https://github.com/sam-github/libnet"
  url "https://github.com/libnet/libnet/releases/download/v1.2/libnet-1.2.tar.gz"
  sha256 "caa4868157d9e5f32e9c7eac9461efeff30cb28357f7f6bf07e73933fb4edaa7"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e35635f157e1fa140f454b451ef60d5dadc60f0f7513fbcd82399193d4ab9155"
    sha256 cellar: :any,                 arm64_big_sur:  "bc8839eea92ce445c790f503ec9342bbc254fba52751a3ac0ed90b5d13bed2f6"
    sha256 cellar: :any,                 monterey:       "8fbd2bdf18193db957bf4312cf8b3d90ded8a141831430350a9e60f13d421e40"
    sha256 cellar: :any,                 big_sur:        "9ecd86c12061ee31384cc784031ee4b0fb05e3ae79ff6c4c6b3f2e61690e8ad4"
    sha256 cellar: :any,                 catalina:       "0ecfbf2539a6e051ca8aa5962c0ee7cb57ffd173cf654b0eec8152c1a3fbf133"
    sha256 cellar: :any,                 mojave:         "cadba638a54f4d5646a3510439ab89317ed23df3c45b12704b78065bb127fbc4"
    sha256 cellar: :any,                 high_sierra:    "44e7b11e8f900f9d6f8e0d1a5deed99c46078dd2dbc997937f713ce5a1ac0f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "755c46e11346388df5a8a3e2f50bf7bb449abfc889abfc561a1784e5d17c8b97"
  end

  depends_on "doxygen" => :build

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
