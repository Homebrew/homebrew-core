class CmarkGfm < Formula
  desc "C implementation of GitHub Flavored Markdown"
  homepage "https://github.com/github/cmark-gfm"
  url "https://github.com/github/cmark-gfm/archive/0.29.0.gfm.0.tar.gz"
  version "0.29.0.gfm.0"
  sha256 "6a94aeaa59a583fadcbf28de81dea8641b3f56d935dda5b2447a3c8df6c95fea"
  license "BSD-2-Clause"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "5704adaff97225f3119dc9249b6d0fd6655c323aa6389473066435ad0a6b1e40"
    sha256 cellar: :any,                 big_sur:       "718e29fe5b922ee5c55dae56a8614832bd6dccb974bd83bb0aee39f02f20db31"
    sha256 cellar: :any,                 catalina:      "c5a339c14cee2d08621b8ce8913462e24193b3bb9247a5a207c6b60c0b9a28de"
    sha256 cellar: :any,                 mojave:        "27144ced3954fbd19c2f7a12ce91c86cc1d8b91425109457b06a87fded64741d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d3486676c02016e58b30ba0f4d9fd7e968d0766b0a961d4d9a3b403997fb5c9"
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
