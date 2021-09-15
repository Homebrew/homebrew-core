class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "https://github.com/arturo-lang/arturo"
  url "https://github.com/arturo-lang/arturo/archive/v0.9.77.tar.gz"
  sha256 "432239cadc4223b1bcdf79ae5fcf8d25deca442cd8865d7e4c16aa932ddee9f8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "cb959d646145de02f2a9c75bf39a9c25c305c5215d35532515ecf29e8771c3de"
    sha256 cellar: :any, big_sur:       "e577c8bdcc06741de97214f15541071cec57cfc5cecea62c3273b188978c3fcb"
    sha256 cellar: :any, catalina:      "bdd63665656f3d66a972fcb7a0a9ff5e8fa5d45fdba8da51bff3ef150925b40c"
    sha256 cellar: :any, mojave:        "9e8ba06684fc4f00daaeb6041d7fb955faabbe1b673f8fc2fd9b68733f49bc06"
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
