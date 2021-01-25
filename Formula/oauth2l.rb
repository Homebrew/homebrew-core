class Oauth2l < Formula
  desc "Simple CLI for interacting with Google oauth tokens"
  homepage "https://github.com/google/oauth2l"
  url "https://github.com/google/oauth2l/archive/v1.1.0.tar.gz"
  sha256 "4058dc07fb9a4e985472068b80e9504b477102b1a0cd999f9367736a5ddb6be5"
  license "Apache-2.0"
  head "https://github.com/google/oauth2l.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "178ad09db5c5cea0075981a832cd143da1ccea0f5224f3c9bf518b5549fb367f" => :big_sur
    sha256 "af0eb0cf2c933afb45eda9aee0b19cd972e16db5b5a5843595397a68348a044c" => :arm64_big_sur
    sha256 "4dedbbebe5996581e6a6c41500abded4f96b0d888e7b68e64584b846d196967e" => :catalina
    sha256 "3cdb4abb44ae3fa046446c28a54225ab46efa736a6cc5dcab80d7156c8f78348" => :mojave
    sha256 "d52fe266287cba01a822204ae32770cff65a244011a69f5306d9d38071c6385a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"

    system "go", "build", "-o", "oauth2l"
    bin.install "oauth2l"
  end

  test do
    assert_match "Invalid Value",
      shell_output("#{bin}/oauth2l info abcd1234")
  end
end
