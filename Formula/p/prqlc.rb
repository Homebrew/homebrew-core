class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/PRQL/prql/archive/refs/tags/0.13.14.tar.gz"
  sha256 "fe92e306de6840ad55217684c88fc38ab1cd074a3e90cda7c124f00ee803b6e4"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5992b5af2fa82c7f0bb8b5a0f43ca403d0c8b3a6162e818fd20d1b7deb0c770"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aab1b6b25ed90584c6e9bb73b1a4db1cc2d281c7ca641d9380036d4e252046db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82d0c23d86ec71eb6e6dbd6bebad90ecafdfeca61146157d9444874cac9a8a0b"
    sha256 cellar: :any_skip_relocation, sonoma:        "19407f91b3c49c3ad91b630fc4017ff9ec5b5589a15548711d6c420188793605"
    sha256 cellar: :any,                 arm64_linux:   "3fc7eb43aeb5875a52bf6a9fc6620dd2e8392b2e427e688c71f390f9feff9b8e"
    sha256 cellar: :any,                 x86_64_linux:  "dd89025764e7bbabd024a4f92cad5d4908661f546020059645ba7fe47b876b46"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prqlc/prqlc")

    generate_completions_from_executable(bin/"prqlc", "shell-completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prqlc --version")

    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
