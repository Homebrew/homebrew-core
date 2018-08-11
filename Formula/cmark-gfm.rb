class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark"
  url "https://github.com/github/cmark/archive/0.28.3.gfm.14.tar.gz"
  version "0.28.3.gfm.14"
  sha256 "c79e12309ff29ed36fb3e5166cb0e77331e708e087e1cc5bee01cf5127a9d2ac"

  bottle do
    cellar :any
    sha256 "276bbc796eab66793b376322130df13d2578fef701fb782942a18b4ce5aa3632" => :high_sierra
    sha256 "faca999f5bedc8e6625b24e80d132071cf6749068877989ebcd2e6b24df81d47" => :sierra
    sha256 "e1f4a4e8483ffae8dac10b085550f8913b125fcc39be0d25903aeb161712f4fd" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "python" => :build

  conflicts_with "cmark", :because => "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end
