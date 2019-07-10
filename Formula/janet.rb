class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.1.0.tar.gz"
  sha256 "e58f8294d985140ea88ce7dfc0c79b5e83a0134fa5838ba3cb62afd36a362d1a"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "3cb7560777df56ac58d3e355d0eb590c7238339dd692add082e37465f4c1f38e" => :mojave
    sha256 "9496e070e64363bd9bd23940b89d47bbca77914c3c4d494d9e013c3c0dba0bfd" => :high_sierra
    sha256 "1b6604847bb3a6c2152751f9add856ebe0a8b5b52c0e9cc9407da83196c2f525" => :sierra
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
