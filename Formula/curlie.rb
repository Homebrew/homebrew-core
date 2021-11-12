class Curlie < Formula
  desc "Power of curl, ease of use of httpie"
  homepage "https://curlie.io"
  url "https://github.com/rs/curlie/archive/v1.6.7.tar.gz"
  sha256 "25a0ea35be6ff9dd88551c992a0f7ea565ce2fae8213c674bd28a7cc512493d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38833a4eb448889240f2a5dbf9627c1f3253e60b284385d6778e32557da8a09c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c765bf3a15919c4452fb9cf470f30f274ecc77c39a1033e262aca4306b799981"
    sha256 cellar: :any_skip_relocation, monterey:       "53b67f688bfc1e16d4eae82601f81825167f3ff6a9bc31731e519efe2de53221"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9e22d8ea5d1459740bc0c0f7a8eac471fd81dc4411af99659fd0d7a36583922"
    sha256 cellar: :any_skip_relocation, catalina:       "b9e22d8ea5d1459740bc0c0f7a8eac471fd81dc4411af99659fd0d7a36583922"
    sha256 cellar: :any_skip_relocation, mojave:         "b9e22d8ea5d1459740bc0c0f7a8eac471fd81dc4411af99659fd0d7a36583922"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88e6f1236f129fd2268636d89dad87549739e55050fa23a966fbba5e33517aa4"
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
