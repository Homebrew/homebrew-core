class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://github.com/github/cmark-gfm/archive/0.29.0.gfm.6.tar.gz"
  version "0.29.0.gfm.6"
  sha256 "b17d86164c0822b5db3818780b44cb130ff30e9c6ec6a64f199b6d142684dba0"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e319253d9762d75a1d72ba449cedd86a1a2362568b10dd91fdc0b7d60ba7435d"
    sha256 cellar: :any,                 arm64_big_sur:  "30b8c1e28d62302b0b91d260315bd4208ece7edb582ba9cb1ee90ed32df44ea3"
    sha256 cellar: :any,                 monterey:       "c6c52d9b82aacdcb35dd8e92ac20815c419c15a648bcc4ff9345c43346c8f93c"
    sha256 cellar: :any,                 big_sur:        "27fa10766c92a82c2fc81485c21ebd2ba37da3730fd3032d4eb51b71eb005d64"
    sha256 cellar: :any,                 catalina:       "caa4c5bf3a77a079799e330f17af0144dcb9b068f0f5a55978c1142591743ef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a03572908861ae5eaf0c1e611d68e40c391097917ed8f87287b3adc46f6595a"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

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
