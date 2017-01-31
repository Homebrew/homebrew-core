class Catimg < Formula
  desc "Insanely fast image printing in your terminal"
  homepage "https://github.com/posva/catimg"
  url "https://github.com/posva/catimg/archive/v2.2.2.tar.gz"
  sha256 "1fa775db2bbb94dc2c66646c8a87edcfdcba878d686d61390d4264c2618673a9"
  head "https://github.com/posva/catimg.git"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "0b7fd950e69a30a4ad80df044382f0c293cff201307c55b197b7ddc05fb8ce62" => :sierra
    sha256 "f0c4ac9ad8929a09fd243d11c1463b8b703eb176e11a2ba5f9d84a580f04f947" => :el_capitan
    sha256 "c581301fe98e1b2de9fec6e8045845297bcd47144affd5fabab58d5a9b3ede4b" => :yosemite
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
