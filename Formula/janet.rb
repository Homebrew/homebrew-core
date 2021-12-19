class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.19.2.tar.gz"
  sha256 "02ff892f4bfc060a8a37f4a5c3e659bf34ba5f1f1c5eb07d60dc2642c5cf0476"
  license "MIT"
  head "https://github.com/janet-lang/janet.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5f8328a386323763770d5df1e9eb77376a8da5fd792cb5fe1b31111409bae9e3"
    sha256 cellar: :any,                 arm64_big_sur:  "830830fdd3cdbb0c44a10653f06be50dbdd06941d7e92a105e1b5185a21d6f13"
    sha256 cellar: :any,                 monterey:       "603ac912862b4ef3a66121ea0e1ef2c25862e5e3d6b279cda4841b78823c09a6"
    sha256 cellar: :any,                 big_sur:        "53904ef10ffa3da98a8615a05824cc160ccea21b24c76eb024d712cebb118a45"
    sha256 cellar: :any,                 catalina:       "c1a5f46a51e87b5b03a59e90d60b9bd7ab87c0e38a7e63c017080f55c6ef1d37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d8260e7ce32662cd783293e347a54b56a1cb1e43a928648d15d17d327987d7a"
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
