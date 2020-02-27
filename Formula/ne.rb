class Ne < Formula
  desc "The nice editor"
  homepage "https://github.com/vigna/ne"
  url "https://github.com/vigna/ne/archive/3.3.0.tar.gz"
  sha256 "77a0c8e8564a29cd18069eebf04cee4855fae183f1e8f25d5fbb0c2651f07e6c"
  head "https://github.com/vigna/ne.git"

  bottle do
    sha256 "b2e63b8951fddb36962eb804a710c507c145e86df8e050ab9e50210002e99b59" => :catalina
    sha256 "198266ab4d3dc24c0f5a4e877f9c4a8add816c11aabfe770549df188b54765a7" => :mojave
    sha256 "97401cdccd3bc86869c6d3208a4cd2044aad1cc11e25fa3369904eece174207e" => :high_sierra
  end

  depends_on "texinfo" => :build

  def install
    ENV.deparallelize
    cd "src" do
      system "make"
    end
    system "make", "build", "PREFIX=#{prefix}", "install"
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
