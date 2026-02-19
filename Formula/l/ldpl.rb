class Ldpl < Formula
  desc "COBOL-like programming language that compiles to C++"
  homepage "https://www.ldpl-lang.org/"
  url "https://github.com/Lartu/ldpl/archive/refs/tags/LDPL-5.1.0.tar.gz"
  sha256 "f61c0a8a3405965a7ee168da3ecf754b600de5a1c89208ae437ffba8658b2701"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "0b4e78d126c188ebd64b75565d021fb50e83c1254ba7964961b6d2d8ebea60d3"
    sha256 arm64_sequoia: "592ca4a7cdb51c66d42595b54a9c25c319505d9d381718dbe80fd1c046c65f9d"
    sha256 arm64_sonoma:  "c0d4f877c0e73299ff867d53ca7041bbcd4a6b73cd8799292920a08d25e9de6f"
    sha256 sonoma:        "59bf789c52ad3829174aec9d44e85be7dd32c077c226aefecf4fa4cde0a878ba"
    sha256 arm64_linux:   "fb841150d1ce3ab5de353c4f5a6c9eaa9caa63ff816c4aacb7c179fd5a36c92f"
    sha256 x86_64_linux:  "b8266370542b6a1d279f3b461cdf52885e9e5b5cf6d65009c5002542e922f03a"
  end

  def install
    # Workaround for the error: '/usr/local/lib/ldpl/ldpl_lib.cpp' file not found in tests
    inreplace "src/ldpl.cpp", "LDPLLIBLOCATION", "\"#{lib}/ldpl\""

    system "make"
    system "make", "install", "PREFIX=#{prefix}"
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
