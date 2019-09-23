class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.3.1.tar.gz"
  sha256 "f14de9e2e1db5707e48a15f4262f4ce8c9ff99b2b3abc59ea6a1493d54bd4ed4"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "d31807cbba33a8b71b691ba3e4c40c937aa0a71a67964b167a6f6427416f1dd6" => :mojave
    sha256 "289857d4a051e52bb8cb701baa611cd5265812828ef23c82dd27aadef6312f6a" => :high_sierra
    sha256 "1d8d9e05632191158c25d3495c5ca5148239741b4d4e801c6964238c4d0e5ec6" => :sierra
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
