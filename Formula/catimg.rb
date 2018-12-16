class Catimg < Formula
  desc "Insanely fast image printing in your terminal"
  homepage "https://github.com/posva/catimg"
  url "https://github.com/posva/catimg/archive/2.5.0.tar.gz"
  sha256 "8bbeeb18d4a5531dd8b86b130cc823cb9d0942f7b6e7013de70c251259a3a922"
  head "https://github.com/posva/catimg.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ca0b3ff26790b12fde4382bba62032d422b0c8148817faf553bf0fa850dc37b" => :mojave
    sha256 "acdb443c28828a2516dd31976f04e75cc849a4db282a177752a99385d925af55" => :high_sierra
    sha256 "b003fe4bb7c6f605143cfae9d061abb64669759bcb691c7bc063b6a71409f7b8" => :sierra
    sha256 "6bc7df392cf75f39e2d0a81080ebd7ca56f6a878c3108617a9831cdb74dffacb" => :el_capitan
    sha256 "e689ddb6558a7657d5d17e79d29a387ba63490603a902079f47f25e3112525a3" => :yosemite
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-DMAN_OUTPUT_PATH=#{man1}", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/catimg", test_fixtures("test.png")
  end
end
