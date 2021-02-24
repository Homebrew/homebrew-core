class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.15.2.tar.gz"
  sha256 "9d08e24c1beaf01231fde469a097ae04c51673be37ab25ca6fef82324a8f7ee9"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "dff29c0c26cec2311b2f000522d8ee9ead4292c1da3aed2bf3923b59f155d75b"
    sha256 cellar: :any, big_sur:       "ebd3cecfc33fdd293537957c60236a303195ffd6fc78ced1c4c6be1b6701dfb1"
    sha256 cellar: :any, catalina:      "c18a3e5f88ec8a1ba67d2cc756b98417e2352acef7b7fb02b8703c6b9e47e6ef"
    sha256 cellar: :any, mojave:        "390ff0f65a113cdd9edd0beb7822bd2e440700dbc3ceaa8559f3697c19786b98"
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
