class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.2.0.tar.gz"
  sha256 "e824ee2da7dffab10bb7ce28917b57a82df82eebf713ad2bbb74ed7be36bd4f4"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "28e93cf80bead32ff813985048d2eb072e77ba22bc1580842bb33d2e12141673" => :mojave
    sha256 "77664d1cab39143e70cf9ddecd9e6ffbd79ff7fc750226d4d3d6a291a8a7b47f" => :high_sierra
    sha256 "ce350380ae23cab8bc40a9672d67bb0a52889faa11a57910c44edae4306e2847" => :sierra
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
