class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://github.com/github/cmark-gfm/archive/0.29.0.gfm.1.tar.gz"
  version "0.29.0.gfm.1"
  sha256 "ebfa3608b3de94f179cbbbeab36df703e3161ae027719f46ab750a7eccf5aa70"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "8cb2c954bae334d1e4727d92b66a5d63a7bb38726dfec6a7b180e530630b6f9c"
    sha256 cellar: :any,                 big_sur:       "0817c1a93b837312aa20c61e783ce18d320cb5c6145f222e83fe00e573a27f7e"
    sha256 cellar: :any,                 catalina:      "58c393b2838a1ed2b74d421bf2de193e6f11626887c79ed5752314fdb4182d2b"
    sha256 cellar: :any,                 mojave:        "8b3f009f2236af2cef7787f773ec3f8b40446bac4960d5f762c6aa690ad2d759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a7e5e8ceb961dedd08919868be0eed5fc37b8292a02a220944508be807f7c96"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build

  conflicts_with "cmark", because: "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark-gfm --extension autolink", "https://brew.sh")
    assert_equal '<p><a href="https://brew.sh">https://brew.sh</a></p>', output.chomp
  end
end
