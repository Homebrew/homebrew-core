class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark"
  url "https://github.com/github/cmark/archive/0.28.0.gfm.7.tar.gz"
  version "0.28.0.gfm.7"
  sha256 "71864744c1ff67e9795cd33fd53a43e56cd9e1938127d5953178af5ecf0cb9d8"

  bottle do
    cellar :any
    sha256 "3a4c16df853cfc4da8a621bb4502642f07f1fa9d395e0281cde6f672a597a3b9" => :sierra
    sha256 "86057b39d955ab14b141768855870405ad8532c239c0ad13748372e8c2dae068" => :el_capitan
    sha256 "f0d4762bead7448ff09342eeae8981504b6426346a9e89a9368d287a7bdc5802" => :yosemite
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
