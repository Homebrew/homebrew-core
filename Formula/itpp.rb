class Itpp < Formula
  desc "Library of math, signal, and communication classes and functions"
  homepage "https://itpp.sourceforge.io"
  url "https://downloads.sourceforge.net/project/itpp/itpp/4.3.1/itpp-4.3.1.tar.bz2"
  sha256 "50717621c5dfb5ed22f8492f8af32b17776e6e06641dfe3a3a8f82c8d353b877"
  license "GPL-3.0"
  head "https://git.code.sf.net/p/itpp/git.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/itpp[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "23dde1c42eafdbba4fb7f2d5f26ae5115706fca6104de839903d1394e48a525d"
    sha256 cellar: :any,                 arm64_big_sur:  "6108f6abf3ec7cd2e4a3b1d3d36dce2cc59327b01d7168705cc1e6b6976c3976"
    sha256 cellar: :any,                 monterey:       "85f1d652165756860f4f4c8ecc86e583ab9b58ec803804bf278a724319790c11"
    sha256 cellar: :any,                 big_sur:        "05b2e27723a47b64d46abb221ac931cbd4f530c2bea166ff4a75c6cc6aec496f"
    sha256 cellar: :any,                 catalina:       "e35e75d21d3414bf4586b7ca6ee2ff1f99b8fd7106bf32c7eec434b2de5135d8"
    sha256 cellar: :any,                 mojave:         "9c4b59029023095449f5592cf26420418af874263b49980a255d084c3f6c8a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "804cfd8e327183c284a6018f22613896b1876aa2b5fffe99e7ecd594d6f4b006"
  end

  depends_on "cmake" => :build
  depends_on "fftw"

  def install
    # Rename VERSION file to avoid build failure: version:1:1: error: expected unqualified-id
    # Reported upstream at: https://sourceforge.net/p/itpp/bugs/262/
    mv "VERSION", "VERSION.txt"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end
end
