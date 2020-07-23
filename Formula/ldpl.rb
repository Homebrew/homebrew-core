class Ldpl < Formula
  desc "Compiled programming language inspired by COBOL"
  homepage "https://www.ldpl-lang.org/"
  url "https://github.com/Lartu/ldpl/archive/4.4.tar.gz"
  sha256 "c34fb7d67d45050c7198f83ec9bb0b7790f78df8c6d99506c37141ccd2ac9ff1"
  license "Apache-2.0"

  def install
    cd "src" do
      system "make"
      system "make", "install", "PREFIX=#{prefix}"
    end
  end

  test do
    (testpath/"hello.ldpl").write <<~EOS
      PROCEDURE:
      display "Hello World!" crlf
    EOS
    system bin/"ldpl", "hello.ldpl", "-o=hello"
    assert_match "Hello World!", shell_output("./hello")
  end
end
