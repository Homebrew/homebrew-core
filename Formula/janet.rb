class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.9.1.tar.gz"
  sha256 "02724d6074a0d6fa53a548e8bdaaf49999f082e30b277c73444900f739a53062"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "b0f87aeaeeb946fbf7182d6e61e05893805a128183c2f284601fe4e26225b907" => :catalina
    sha256 "49894dbf5bc695d03f34fe3d6a85c7f136146dc41b938f41b63f709ad52e2cbb" => :mojave
    sha256 "e7deb281b982a08f3db52e945e5f7e16be8893ff8542157fb31d86e9ede70467" => :high_sierra
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
