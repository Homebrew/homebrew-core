class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.3.1.tar.gz"
  sha256 "f14de9e2e1db5707e48a15f4262f4ce8c9ff99b2b3abc59ea6a1493d54bd4ed4"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "6345f08de3dac2dba6325d0c22d091b77f8ce0f590f9905a94689f6b7c8439cd" => :mojave
    sha256 "a7b7e3d2cb910157d994d2a1b075ad0229470306c07aa5c6ae7041a0f51eb641" => :high_sierra
    sha256 "874d308a5a1fdcff9109095612a3c78af38a2a85c84f53f8de2b7870d1425590" => :sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", "--buildtype=release", "--prefix=#{prefix}"
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
  end
end
