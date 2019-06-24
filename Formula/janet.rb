class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v0.6.0.tar.gz"
  sha256 "1226240f8ed7f5faafbff6d93e5802c7959c4b40f9212ac6f020d67ef3aa599e"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "d71616a90f9325ff880f49ee33160634b52e2ffa1775e1f6f718690acf8b430f" => :mojave
    sha256 "14cc9e8261b68bebff521ee58337caea76f6ad825e2ea96539f7d34e13ebee19" => :high_sierra
    sha256 "1f1af1a159b155f3190e57a6143cccad6d7393affd47048f3c319dc136d6044f" => :sierra
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
