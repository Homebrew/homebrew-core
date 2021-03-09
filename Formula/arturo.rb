class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "https://github.com/arturo-lang/arturo"
  url "https://github.com/arturo-lang/arturo/archive/v0.9.7.2.tar.gz"
  sha256 "ac0c07cedfa700763e9e300cb84e058a3db1b76429eff4a2dca4ce912e971d38"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0f1a9623d87d1e4c29d1439a0b168da86705c7ebdf98762dbf79994a0358f9c7"
    sha256 cellar: :any, big_sur:       "1bc0387d27bcc2542c5b93e50a835381413c22e48eb51e31ac5e5026d338ff4c"
    sha256 cellar: :any, catalina:      "4a8e50e0a256a012492d960d8c06d57d4e43940b2dfcffa78cd1895a4e47f037"
    sha256 cellar: :any, mojave:        "02ab700850cc749e8461e9196bba70eb3536fbf8e0613d9a485003ffa7b49b65"
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
