class Janet < Formula
  desc "Dynamic language and bytecode vm"
  homepage "https://janet-lang.org"
  url "https://github.com/janet-lang/janet/archive/v1.12.2.tar.gz"
  sha256 "1cdbc4e944fb429a80bb415b657fc955579a4d7b1206fed9b32b9c60b20e477c"
  license "MIT"
  head "https://github.com/janet-lang/janet.git"

  bottle do
    cellar :any
    sha256 "1181c2738d9c4479f7d46f5d9518955369b19fad9814eabb3b1481ee0d2055a0" => :catalina
    sha256 "594711312d351ef2f2c97c9fa1d1212e23f20cb36b4f0b685ab2ba35a9a6fb83" => :mojave
    sha256 "53f6d8aba6d1b8a6804c497a34370172b4801cfa1bb76c403a3a9a5894e820cb" => :high_sierra
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
