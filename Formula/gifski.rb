class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/1.7.2.tar.gz"
  sha256 "a686cba9b9874d06ff138249119b796960d30fa06d036ce51df93d8dde6b829f"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "af9c98c8a9ab8aa67fb3da6e066b0bed3461af85c4c1f1447ff902ac107bebad"
    sha256 cellar: :any,                 arm64_big_sur:  "b0ebe9732a9a0f7135a7075b83867510f032dc006f57c53400a6e30943063035"
    sha256 cellar: :any,                 monterey:       "0d6317ef5e4b8ad59067961d9dbfd5859c2423c77a3048effc6e57820850cad8"
    sha256 cellar: :any,                 big_sur:        "603f7ee3089fec883251366f11da096177f4d0c93c082e199a62053820ee0c42"
    sha256 cellar: :any,                 catalina:       "d561aa06de8058b632fba03eecbe32b5694d8c529cebe538ef928d3c29801b1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69c36d25386c9fb03907ed080320f84a0f096ac0c8566879f5cefcbe1b72decb"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg@4"

  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # rubberband is built with GCC

  def install
    system "cargo", "install", "--features", "video", *std_cargo_args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_predicate testpath/"out.gif", :exist?
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
