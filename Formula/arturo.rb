class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "https://github.com/arturo-lang/arturo"
  url "https://github.com/arturo-lang/arturo/archive/v0.9.77.tar.gz"
  sha256 "432239cadc4223b1bcdf79ae5fcf8d25deca442cd8865d7e4c16aa932ddee9f8"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "401dff38cee00697ebd9b63208c3e4fdaa80efc01fea192f88d887d9fee1b78e"
    sha256 cellar: :any, big_sur:       "415ec5e93df66bfe2f0c547ea644c26395037d9a925640070cc1a4f72fbb3913"
    sha256 cellar: :any, catalina:      "ca9f91d5b09d9ed6a66c162920bf9f5ec9f9347f6752577db49c3ce546b3459e"
    sha256 cellar: :any, mojave:        "ac67c5b310e35cf5c17d923087dcd72797df30d0fada760217d7c9da83091921"
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
