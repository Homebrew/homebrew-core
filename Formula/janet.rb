class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.14.2.tar.gz"
  sha256 "587715eddbe007cbd33f16c89cc3aabc67a69196669b3c6995ce983dc00b54fb"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "b35836d527340c35b9bd7a6188f721dc98fc6483aed408daf4ed425ff637d086" => :big_sur
    sha256 "386bf3477f9d668e9de1533e50f9d22bafd1769d85e49a7b1c1611d6cef7245b" => :arm64_big_sur
    sha256 "0bcca6f2fbcb0354227866430aafba4f5c5bff4db40ec0504ddf5a7618624f35" => :catalina
    sha256 "9bcd478536adeaee5beab677d5463c176ec6818c532210c1fbc96f7f0b96b127" => :mojave
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
