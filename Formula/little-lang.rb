class LittleLang < Formula
  desc "Statically typed, C-like scripting language"
  homepage "https://www.little-lang.org/"
  url "https://www.little-lang.org/bin/little-lang-src-1.0.tar.gz"
  sha256 "29da860da52aa9cc238fea13ad8aee743c17fe5bfdbc0e78457a600bdf1ec386"
  license all_of: ["TCL", "Apache-2.0"]
  head "https://github.com/bitkeeper-scm/little-lang.git"

  depends_on "ghostscript" => :build

  def install
    system "make", "install", "PREFIX=#{prefix}", "LGUI_OSX_INSTALL_DIR=#{prefix}"
  end

  test do
    (testpath/"hello.l").write <<~EOS
      string where = "World";
      puts("Hello, ${where}!");
    EOS
    assert_match "Hello, World!", shell_output("#{bin}/L hello.l")
  end
end
