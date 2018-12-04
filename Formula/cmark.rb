class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "https://commonmark.org/"
  url "https://github.com/commonmark/cmark/archive/0.28.3.tar.gz"
  sha256 "acc98685d3c1b515ff787ac7c994188dadaf28a2d700c10c1221da4199bae1fc"

  bottle do
    cellar :any
    sha256 "71124568c50ed9e71eeab7ae42efcb0c2bba219f0dfa1d28754266399409ed92" => :mojave
    sha256 "c0999bf5cc1d453259d34c1c2332572cf6cf07ff848021257529bb4be98def00" => :high_sierra
    sha256 "15f85443980a06a2faed8de4b3165a8e6830d15a6adb90689bd1f1faa6fb8f3c" => :sierra
    sha256 "5b24b8685ed9a8912cdc8479ebccd12027bed33b02554980c0e6588cbccb581c" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "python" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_INSTALL_LIBDIR=lib", *std_cmake_args
      system "make"
      system "make", "test"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark", "*hello, world*")
    assert_equal "<p><em>hello, world</em></p>", output.chomp
  end
end
