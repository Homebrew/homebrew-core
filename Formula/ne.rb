class Ne < Formula
  desc "The nice editor"
  homepage "http://ne.di.unimi.it"
  url "http://ne.di.unimi.it/ne-3.1.1.tar.gz"
  sha256 "ec4f5d919c38b1a5938b609a722d0d88a68c404b4564e3bb654b96b30582add9"

  bottle do
    cellar :any_skip_relocation
    sha256 "ebf14e2778e53688a4c1c0051187b79994e9374fc599332b20b0b362d6517c49" => :high_sierra
    sha256 "1aee5fa253900a888bfa27d92a3b0e262a01acf03da2987285064c916105a388" => :sierra
    sha256 "7bdd3016890a03f6bc006d924cf2373a97b3915bf8d7ddc1a6bb81741085ecff" => :el_capitan
    sha256 "00d0ed886fa94db6b33f26dd304f468c79748379ac95c49a96141594fa0b333a" => :yosemite
  end

  def install
    cd "src" do
      system "make"
    end
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    ENV["TERM"] = "xterm"
    document = testpath/"test.txt"
    macros = testpath/"macros"
    document.write <<~EOS
      This is a test document.
    EOS
    macros.write <<~EOS
      GotoLine 2
      InsertString line 2
      InsertLine
      Exit
    EOS
    system "script", "-q", "/dev/null", bin/"ne", "--macro", macros, document
    assert_equal <<~EOS, document.read
      This is a test document.
      line 2
    EOS
  end
end
