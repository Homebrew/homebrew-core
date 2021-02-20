class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "https://github.com/arturo-lang/arturo"
  url "https://github.com/arturo-lang/arturo/archive/v0.9.7.tar.gz"
  sha256 "6c592598a454a1354d711e2ad6ee950cc51741726433a0b3395b488ebe3f52a4"
  license "MIT"

  bottle do
    sha256 cellar: :any, big_sur:  "41839323ddd7df3ebd285753b585e80b8cdd8aa12398c979e5510c415fcd3ee7"
    sha256 cellar: :any, catalina: "62eafe349de67ca3c97ecdc2487dde8700c9295155ee829957fe6d2421ef14dc"
    sha256 cellar: :any, mojave:   "183fe6c792e94ffc9c50bc9ab138e6e11622284720798c0f0b01bb12b73b1373"
  end

  depends_on "nim" => :build
  depends_on "gmp"
  depends_on "mysql"

  def install
    inreplace "install", "ROOT_DIR=\"$HOME/.arturo\"", "ROOT_DIR=\"#{prefix}\""
    system "./install"
  end

  test do
    (testpath/"hello.art").write <<~EOS
      print "hello"
    EOS
    assert_equal "hello", shell_output("#{bin}/arturo #{testpath}/hello.art").chomp
  end
end
