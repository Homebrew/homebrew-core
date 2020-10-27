class Ldpl < Formula
  desc "Compiled programming language inspired by COBOL"
  homepage "https://www.ldpl-lang.org/"
  url "https://github.com/Lartu/ldpl/archive/4.4.tar.gz"
  sha256 "c34fb7d67d45050c7198f83ec9bb0b7790f78df8c6d99506c37141ccd2ac9ff1"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e5cd92ebf4f0babb34d7af78189e7915731fad5fac39e66d63ecbbce86a72d0" => :catalina
    sha256 "b9a0fdeb6134828ef4f60d81339185c5ac5a86123d6301035cbfb3b45c1a91ed" => :mojave
    sha256 "01f2a987ba4b74d1b50374c7a9a616703a2a8ad479aaad8b80ed8e936af91d80" => :high_sierra
  end

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
