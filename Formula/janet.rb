class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.1.0.tar.gz"
  sha256 "e58f8294d985140ea88ce7dfc0c79b5e83a0134fa5838ba3cb62afd36a362d1a"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "4fc98c605dfe11f34b852a84956d03e67c3a2e438e759dad113780c233bba9d8" => :mojave
    sha256 "b421d9dba37de455d4b59b4d7af519ede2ec9e37832a8109009727456c2a285c" => :high_sierra
    sha256 "ea063058317fb9c858bb7d10e93a1bcd6d99e09e3629cf82f699ea50215e67c4" => :sierra
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
