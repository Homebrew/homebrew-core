class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.21.1.tar.gz"
  sha256 "8c6eeabbc0c00ac901b66763676fa4bfdac96e5b6a3def85025b45126227c4e0"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2f7130ecaaeb52c2230ae07f48182771d347d55b8ba07f3f954ba5e9a7031a96"
    sha256 cellar: :any,                 arm64_big_sur:  "4bb55fb69e5908adce3c310a4d231e4c6d65a916990d24daf3e7330002560b34"
    sha256 cellar: :any,                 monterey:       "c794246619ccd79ab85f78437ec996a5e6492a4b781d07254a7325b368f47250"
    sha256 cellar: :any,                 big_sur:        "419a53481c6b75ba83f46d74c3dd113925f39e2141d4f74ac5e7f403cf2368b1"
    sha256 cellar: :any,                 catalina:       "613cae70f1dda5da9acbd7fcefd92539a83d7b9ca20c90312215787d1e456fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1509aca7f75bc88498c028e4e9773b0c7b7d8c6b77f4e506e79a3c894fc004f4"
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
