class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark"
  url "https://github.com/github/cmark/archive/0.28.0.gfm.5.tar.gz"
  version "0.28.0.gfm.5"
  sha256 "99a4625cadb2c31f1a5f7abf7b5688f4b1595efd1863b71f347a2ad9b9ddce9d"

  bottle do
    cellar :any
    sha256 "925f87348c32e8b7bb09f90c31f9601c1b818d9d1b35e49ed33e132d100ddef7" => :sierra
    sha256 "aac20ff48e84d30ae753cc92e16e54a9bbf5a4382314e863f7c2fce9b1286252" => :el_capitan
    sha256 "d1c19f3364f39aef9b248e57a1c73d7ac3c8ffac1d97868b0d5f3efa9fb85976" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :python3 => :build

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
