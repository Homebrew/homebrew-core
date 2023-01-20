class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.4.1.tar.gz"
  sha256 "b60df362a0b823600ccc614c335f4a8876a577a7ceeb6d162f16540fd9340f73"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "650d49a52514b28dd6438c841dbe49386d227ba96b73d14fe85a582f5afd279f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "28436c6cdae7975627d587727e83c0654eeadfc3161b5692a57702975e97a38c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2cc00b3e6ed1ef772f762575b81d1e56515fc66c9df3cdf7e0c3c02f2b81663"
    sha256 cellar: :any_skip_relocation, ventura:        "070897d6a9848d94f2b48260611ba7965709622c67d0475fa1a4062108020c91"
    sha256 cellar: :any_skip_relocation, monterey:       "12b699203da7adead7bead94dfd279162819c313eccb2910236ed15c25c08407"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee236950a9e00540ffc00b624470ec6ae25f1b86572adc2e4e6c2a3fd355a7f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a58b4b32c8d40e8ddb565a028182388178c0f021b353ee64eac840fbc17a5af5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prql-compiler/prqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
