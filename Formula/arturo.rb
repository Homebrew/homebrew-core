class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "https://github.com/arturo-lang/arturo"
  url "https://github.com/arturo-lang/arturo/archive/v0.9.7.2.tar.gz"
  sha256 "ac0c07cedfa700763e9e300cb84e058a3db1b76429eff4a2dca4ce912e971d38"
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
