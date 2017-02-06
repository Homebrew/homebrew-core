class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "http://www.minizinc.org"
  url "https://github.com/MiniZinc/libminizinc/archive/2.1.3.tar.gz"
  sha256 "dbfcb2420e4babb58313c96c3b34e43d164db0d5036b5845dbbf39a874ac376d"
  head "https://github.com/MiniZinc/libminizinc.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "4f023000b053decfe7111b0b812ca20a54fc7ba20f3fe76e3ff130a24ca89b06" => :sierra
    sha256 "58bfaee6ed74e25328a021cb499b560d4ba6c4a5c77de3c1fc78661d7d944c01" => :el_capitan
    sha256 "4de4a82e617298a527df1fc179f47e449eadfc0c1624cd31103d1b99fdc786da" => :yosemite
  end

  depends_on :arch => :x86_64
  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    system bin/"mzn2doc", share/"examples/functions/warehouses.mzn"
  end
end
