class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/PRQL/prql/archive/refs/tags/0.9.4.tar.gz"
  sha256 "06e18f7b7a6ca6baf167a7791d2fc87d47042a979728146905e0658b7ae00c73"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54f21901c4a182f5384ab95caf9adbcf5ddf3e8d5de39e15563b38191a413fd7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ead63d63b4b987cdf1076fdf17f52bef8cee9ee95270e35f98c2a7b2e35377b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3862737fe576e9e45c996eb13734817da3c189bfd26122df9370d7aac07f83f9"
    sha256 cellar: :any_skip_relocation, ventura:        "18d6cfc92c870538e1d6f3551d37be31faa595faf8957870a87861f0ba206657"
    sha256 cellar: :any_skip_relocation, monterey:       "4aad93706ede8f70f93c94b6a3bb0c34f39cca7a582573fd1d2e996943b812ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "f497be07d02800e6adcbbd2b7732625fed9da7a417bdb41bc9359d0246a319f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9f02ec553ff44364f8fe3ff904a3efc32f19e07631a42d8e58024398b3ad5b4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "crates/prqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
