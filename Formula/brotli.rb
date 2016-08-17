class Brotli < Formula
  desc "Generic-purpose lossless compression algorithm by Google."
  homepage "https://github.com/google/brotli"
  url "https://github.com/google/brotli/archive/v0.5.2.tar.gz"
  sha256 "2b7b1183682a17d8a9b83170fccdbec270c9e56baf8c0082f5d9c4528412d343"
  head "https://github.com/google/brotli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "58d3d62ce9588ea4fab0e5d638f898b445314522847818ac55572ec423ba592c" => :el_capitan
    sha256 "1ad5e3fc7106bceb888193703f757dd1d138d338e64a7ef39d6141b8b3bf9ba6" => :yosemite
    sha256 "62905194568ea45d2a85499d12b06d4c2d713a71c8d5b6d70c0fa5a25cd26aa0" => :mavericks
  end

  depends_on "cmake" => :build

  conflicts_with "bro", because: "Both install a `bro` binary"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "VERBOSE=1"
    system "ctest", "-V"
    system "make", "install"
  end

  test do
    (testpath/"file.txt").write("Hello, World!")
    system "#{bin}/bro", "--input", "file.txt", "--output", "file.txt.br"
    system "#{bin}/bro", "--input", "file.txt.br", "--output", "out.txt", "--decompress"
    assert_equal (testpath/"file.txt").read, (testpath/"out.txt").read
  end
end
