class Ne < Formula
  desc "The nice editor"
  homepage "https://github.com/vigna/ne"
  url "https://github.com/vigna/ne/archive/3.3.0.tar.gz"
  sha256 "77a0c8e8564a29cd18069eebf04cee4855fae183f1e8f25d5fbb0c2651f07e6c"
  head "https://github.com/vigna/ne.git"

  bottle do
    sha256 "9c247087abcddef37c90d601611a7473b871d411340b4af1e72660fa60e829e2" => :catalina
    sha256 "f7eb99d6a26252a621d18ec846920df9319b33c78053771bae8e39eb1997333f" => :mojave
    sha256 "5de11e9bf7bd2cc2d703a61ba43f154fcf93534a76d195627902061cdf70b6bc" => :high_sierra
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
