class Arturo < Formula
  desc "Simple, modern and portable programming language for efficient scripting"
  homepage "https://github.com/arturo-lang/arturo"
  url "https://github.com/arturo-lang/arturo/archive/v0.9.80.tar.gz"
  sha256 "25f4782e3ce1bc38bedf047ed06a3992cf765071acded79af202a1ab70b040e2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d2fefdc8b29ddcc25ec170ee951974c0f0639456ae44f3066b30ba9bfacff832"
    sha256 cellar: :any,                 arm64_big_sur:  "2099288de81442cd767921ad6210904e33a8ebac246fc1a65c07411783116b39"
    sha256 cellar: :any,                 monterey:       "9ff3e59d195ca8aaeba073c03981667094bf97d133e50e177cbafe9bf428095c"
    sha256 cellar: :any,                 big_sur:        "65147c59e9070ca346499761685b22d97d6ce2ad189587ce9e868762dfe780f8"
    sha256 cellar: :any,                 catalina:       "a538cff3a4ee46a2b7744b321815424afa4476e692ee5be671c55c5823bdd06b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c41186a164daa64e8261d523fab9061b6d18fb672494ac4c6504d2b2963ceafe"
  end

  depends_on "nim" => :build
  depends_on "gmp"
  depends_on "mysql"

  def install
    inreplace "build.nims", "ROOT_DIR    = r\"{getHomeDir()}.arturo\".fmt", "ROOT_DIR=\"#{prefix}\""
    # Use mini install on Linux to avoid webkit2gtk dependency, which does not have a formula.
    args = OS.mac? ? "" : "mini"
    system "./build.nims", "install", args
  end

  test do
    (testpath/"hello.art").write <<~EOS
      print "hello"
    EOS
    assert_equal "hello", shell_output("#{bin}/arturo #{testpath}/hello.art").chomp
  end
end
