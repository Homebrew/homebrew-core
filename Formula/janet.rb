class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.10.1.tar.gz"
  sha256 "5d830a01ced5b97f99b9c71a9d869751df72266a88eb7b3ff7a8bff9da39afde"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "a766c0f5fa6d207c030813e03abf3b09ab13e8dcb6a5ce4bad3912017435685b" => :catalina
    sha256 "b6d8f7dd18cf760657d46121b6290402008d4ac21a03a1bac88ff6fb697976dd" => :mojave
    sha256 "6ab63abf4e3f1cd5d4c5bacb367c779bf776153c37c4bfad3c85cf02b52678dd" => :high_sierra
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", "--buildtype=release", *std_meson_args
    cd "build" do
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    assert_equal "12", shell_output("#{bin}/janet -e '(print (+ 5 7))'").strip
  end
end
