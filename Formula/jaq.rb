class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://github.com/01mf02/jaq/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "e78724f7e5191ee0efc4cfe09cc882c5c7df83a118bdc6a193a04f87ed195eae"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86e862291cb785d1734d6ea5e2e63586eed717657ac25c1446a6343c590c4f77"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4f79be6d0840f5fc0ec2344345f0ca502e647ba2c3f9d78b8f8071f855dfcd9"
    sha256 cellar: :any_skip_relocation, monterey:       "86bf4241e63b449e4093f65848d30b5dfe413ee5785ea7072bcb16d6b9f11094"
    sha256 cellar: :any_skip_relocation, big_sur:        "48d247267935c637b6a4859a72207188041e214ae39f879534bd833c8e1fdba6"
    sha256 cellar: :any_skip_relocation, catalina:       "91ae6cfeeefe2144280df1bb7d52f005bbc73503a20cc0341e546e1ece990a44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94a70fbeee2b338cc9444655060ca8c1a5186ee116c65b33f1648e9a73f206ed"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end
