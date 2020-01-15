class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.6.0.tar.gz"
  sha256 "9faa4ed79c9281c4f9c0a005588ef0452a0b77217cd297fc0a73a5fda6d14e5d"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "cb052676c92fdc22357e59ad066f95cf05666823f96c63285336d302dd35eac4" => :catalina
    sha256 "ceee24995e37b582d2b76014a91815d4722ed2e7181de3c76d40ffaf67b783ba" => :mojave
    sha256 "b7cc796a9cecbdc61156c0a74c2b8eaa465178c0d7c2a13bb41969e89c5352a3" => :high_sierra
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
