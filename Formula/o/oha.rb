class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.4.6.tar.gz"
  sha256 "8a68d4411ce241d161aeaa87e9f1e778b381398454bf58e58c976d575fcb2c3b"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2d8394a12ef1d163a0e2a344f29cd9b21feee4fb42272872c8340274c5a6bac8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7271f86c11c845efa1ddaaac6003134b13a84bba8c9098c5181f3350fa454e07"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e231a37455a5615fbe999e4ac87abf1a8f18079b4d98fd220bb68606008112d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a59c9b88c86bc79446a41d7029b4773d2d36d2d12ca1a6da8b3844cfeeee24e"
    sha256 cellar: :any_skip_relocation, sonoma:         "4254122db32fe3bcb2fd62aa4396514306bab62955a015ea67b7ac1f7c7d781e"
    sha256 cellar: :any_skip_relocation, ventura:        "8d9084615711cd10ec4e64c8fe8e6f434d90b3695388f5bf95585b8770e44f66"
    sha256 cellar: :any_skip_relocation, monterey:       "7aab1a89bda91f90a493f5c6e7e1b78fd79c09fe0ffec793beb8cd45ce97c41c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccacae033d20a23b965aa8e112a65c0ce2cc522b47ae600fc7238985dd3bfecb"
  end

  depends_on "cmake" => :build # for aws-lc-sys
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 1 responses"
    assert_match output.to_s, shell_output("#{bin}/oha -n 1 -c 1 --no-tui https://www.google.com")

    assert_match version.to_s, shell_output("#{bin}/oha --version")
  end
end
