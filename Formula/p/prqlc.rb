class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/PRQL/prql/archive/refs/tags/0.13.2.tar.gz"
  sha256 "ee6b683a674d64c4a12893a6c926127e98481767ccb385a0f563dcc862bd199a"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0504c5363097ca60b2387ea9d9fdd3bff87e38042df06e38d02ab98c303132da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01af361385a984959e1c993035eb745aaaf2b339c1393ee76422b4e7484514e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dabb929e4199fc379047d6a999d16343cc8fcc61716dc3ce9fe282b8bc9b0fbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec6af8e56f8e59e8d22e413a6c55b8fc2a86b9086ab6f6cced108212bb197d14"
    sha256 cellar: :any_skip_relocation, ventura:       "ba0f1ff20ac87ee362ec15e860730c03cd410730e038da03ee13f661364e5939"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3c279867650e9820cf28d8709a5a5f4f79d2bcd3292f38baffedef498bc6e57"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prqlc/prqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
