class Curlie < Formula
  desc "Power of curl, ease of use of httpie"
  homepage "https://curlie.io"
  url "https://github.com/rs/curlie/archive/v1.6.2.tar.gz"
  sha256 "4cf14accb5e027fc5ecc5804679a4b52f9aae076b4bdbe33a5c002fc84e0f437"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c765bf3a15919c4452fb9cf470f30f274ecc77c39a1033e262aca4306b799981"
    sha256 cellar: :any_skip_relocation, big_sur:       "b9e22d8ea5d1459740bc0c0f7a8eac471fd81dc4411af99659fd0d7a36583922"
    sha256 cellar: :any_skip_relocation, catalina:      "b9e22d8ea5d1459740bc0c0f7a8eac471fd81dc4411af99659fd0d7a36583922"
    sha256 cellar: :any_skip_relocation, mojave:        "b9e22d8ea5d1459740bc0c0f7a8eac471fd81dc4411af99659fd0d7a36583922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88e6f1236f129fd2268636d89dad87549739e55050fa23a966fbba5e33517aa4"
  end

  depends_on "go" => :build

  uses_from_macos "curl"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "httpbin.org",
      shell_output("#{bin}/curlie -X GET httpbin.org/headers 2>&1")
  end
end
