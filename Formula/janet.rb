class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.16.1.tar.gz"
  sha256 "ed9350ad7f0270e67f18a78dae4910b9534f19cd3f20f7183b757171e8cc79a5"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c08b5f94e48fc9c7a3e534baf4c6475fd2d9403389a11c9d48d34a1cb8c99f5e"
    sha256 cellar: :any, big_sur:       "b4be0006c3cdac451667cd7105110b8daf9b528cffa4788661325b135caf4519"
    sha256 cellar: :any, catalina:      "3d47867722d9e8170126394c64b1682c0aadd1e0065736b701a24062f82f9a45"
    sha256 cellar: :any, mojave:        "c9b10f1796a14db553463faea625c9c16879ab8f1afa06bbf67f88924d01421a"
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
