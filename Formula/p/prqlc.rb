class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/PRQL/prql/archive/refs/tags/0.9.3.tar.gz"
  sha256 "d210c7feb9d6e2cbb0b4cdd085b94f829f1125c311af3937941d0ff6dc6503a3"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f0d1a0a913f2157420bc194e21beb2d8b239756829b0b747998c800cdecfadd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d57b2329d09f29cf82eed25e1a60d398b283d72c4a028981c2fa93519682d50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e16eccbcc7d6909ce07c81f7bef75bbf7a466b27bb62b9f126640936d7578ce"
    sha256 cellar: :any_skip_relocation, ventura:        "2c5aff4d6b18b7b403d24ca648413bcddb534f522702ee9d0e411e7f04a54961"
    sha256 cellar: :any_skip_relocation, monterey:       "4d402f1bb94b26b51e6ae165d5a5df6f841357788eb3bd44d07b23c42db93bed"
    sha256 cellar: :any_skip_relocation, big_sur:        "62765629a9ed074ff1c855fca6464a789ebc8a031451cf6e14bc21d1d464200a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a5fc7f9f3f2faca1761b08a5b8b9c26c19d882285a0a29579f199c2c5192fa2"
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
