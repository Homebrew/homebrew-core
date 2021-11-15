class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.18.1.tar.gz"
  sha256 "bfc29c11a070cc175666f74eb99ea992276d6e269701ba9558a72cef05ac80b4"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "705455f3cc9a547d3694e601ee620c7a58f9a51b6ee1e32eefc3639156814810"
    sha256 cellar: :any,                 arm64_big_sur:  "54a74c42eb9a5613594754888bb758f8c89005b212080e3dc057179d3e82a130"
    sha256 cellar: :any,                 monterey:       "e45dfdb9709a741d34c80d9f83cf59e0452c7817874b2ec886df5fdf8504e72f"
    sha256 cellar: :any,                 big_sur:        "0dfbb7d6613f324cffb47cc2f7c4b0865d104a2be559d2e4f5f5ac43fd5f9a51"
    sha256 cellar: :any,                 catalina:       "a3c0e99db2191455c55689b9d241bea2934e11d469b43c95dcdd8443a751ba4d"
    sha256 cellar: :any,                 mojave:         "3535f49220d2167757143455e51e61c8290523fa46c4e7821037d9b541817efe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daa2c336cb30021515485c28fd3ba90932e767406f0eb4bf7e92575c76110cd4"
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
