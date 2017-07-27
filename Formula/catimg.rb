class Catimg < Formula
  desc "Insanely fast image printing in your terminal"
  homepage "https://github.com/posva/catimg"
  url "https://github.com/posva/catimg/archive/v2.4.0.tar.gz"
  sha256 "3eb475a9463976362470b4aad09442ff1157723e3fc342b125b4b41a055e8fe7"
  head "https://github.com/posva/catimg.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6d8ab22fd51467aa6954cce4133006e36b50d4cdfe33beab20f3fe6d10e95861" => :sierra
    sha256 "4e665f7c1a4ecfd7e1950d6c356dfed8f92d0ab96b27042d5160997e2b019f9a" => :el_capitan
    sha256 "2bbd68a3e61450ce10e98e0ab3be0b79bc7246afec39a64b17b2397febab904b" => :yosemite
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
