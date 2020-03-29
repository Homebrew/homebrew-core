class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.8.0.tar.gz"
  sha256 "e02ae5c7b4579a23e3f30636c16d248273ed119467a076d18c9362e858eb9812"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "549ea7dc72d61b39e4b8769ae134c984a74005f3dc9294720ad413dba650cb31" => :catalina
    sha256 "2f11cba71f79a712dc1133039a82ff22eaef55518b5b4ebb9b3bd384b6ea44cf" => :mojave
    sha256 "858c71bc0bcfb80cc8b938083c0fceb0196dc83f89c2db501d9b8f38db0b6bf7" => :high_sierra
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
