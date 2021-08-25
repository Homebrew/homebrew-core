class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.17.0.tar.gz"
  sha256 "45126be7274e0a298dcbe356b5310bd9328c94eb3a562316813fa9774ca34bcc"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "501fbbf875eae97a5a58232b243cd18cbe5404c7bd2a04baf2d2f3e2f3e58ec2"
    sha256 cellar: :any,                 big_sur:       "37aae6c88efe0f3997ce26862e2bfbe703afb3d2aaa73f79cc927b49887671ee"
    sha256 cellar: :any,                 catalina:      "384b5d1efb1a6dfcd3f9a4d736ca5566a26f5b76baa42222b6113fcab988fdf5"
    sha256 cellar: :any,                 mojave:        "241ea940f9348e212f9c6a0325c44c186d86d9eec9df5ba4d69ad020bd08c4ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3da4662b407a18ed000df67eef2cbac9c6e5c46f038de74c36ab3bc17262248f"
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
