class Catimg < Formula
  desc "Insanely fast image printing in your terminal"
  homepage "https://github.com/posva/catimg"
  url "https://github.com/posva/catimg/archive/v2.4.0.tar.gz"
  sha256 "3eb475a9463976362470b4aad09442ff1157723e3fc342b125b4b41a055e8fe7"
  head "https://github.com/posva/catimg.git"

  bottle do
    cellar :any_skip_relocation
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
