class Curlie < Formula
  desc "Power of curl, ease of use of httpie"
  homepage "https://curlie.io"
  url "https://github.com/rs/curlie/archive/v1.6.7.tar.gz"
  sha256 "25a0ea35be6ff9dd88551c992a0f7ea565ce2fae8213c674bd28a7cc512493d9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5e258bc851da6382ecd91feeb7a3ee6be43521040e28a1127bf988bf3fecdcf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5e258bc851da6382ecd91feeb7a3ee6be43521040e28a1127bf988bf3fecdcf"
    sha256 cellar: :any_skip_relocation, monterey:       "ace5b733c4cc5290044ef382c42d72c67ad813fded0d3cbafba7aacf66dc9df1"
    sha256 cellar: :any_skip_relocation, big_sur:        "ace5b733c4cc5290044ef382c42d72c67ad813fded0d3cbafba7aacf66dc9df1"
    sha256 cellar: :any_skip_relocation, catalina:       "ace5b733c4cc5290044ef382c42d72c67ad813fded0d3cbafba7aacf66dc9df1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69aa5acebd2adddc5fbd0058aa8acafb510e9f6988552c459f13cf4a63669bd1"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  uses_from_macos "curl"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "httpbin.org",
      shell_output("#{bin}/curlie -X GET httpbin.org/headers 2>&1")
  end
end
