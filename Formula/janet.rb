class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.21.0.tar.gz"
  sha256 "8e53efcdeda9b7519248bef5f0e744ad947e013b14960c66ba75967c5fb0a7fd"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1b1ae771f7d75bd5f41b1fab6257c4355944f4c09371e11accae55f9a3c86b97"
    sha256 cellar: :any,                 arm64_big_sur:  "40dd33d1f4bc3135bd8347c6cb645c87b1f0b21d722aabcb09be5f4b68f1aef9"
    sha256 cellar: :any,                 monterey:       "4b8679789c36ec5814f5c0ac02f857bd42f5762ed3fcb081c4c2e3086e82946f"
    sha256 cellar: :any,                 big_sur:        "50adae33630fc12eb90112f2f5c0fc82c20d1a9373aaf96c278b1d273133a06d"
    sha256 cellar: :any,                 catalina:       "426653dc56bf295e88856d6c1455407c5093ac6a46c780f04902fea9018be829"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a570c696a8dd21daeb7a4736d3bddd65d38273d57f90b99dffaa459e083f78a"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
  end
end
