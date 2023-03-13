class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.6.1.tar.gz"
  sha256 "84bb9349129ed14b7ab17361faac3535be5f21b46c9757c1fed96a0e1023dd65"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46370710ba8615b3057e7aeefb06ef9a9dc2ca4fa69e7ffa4ad67faff0d66e56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97bb7871bb5ffcf431cb53d4526e39ff732e8f1c261bb53fce3c0659c32004ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "690ce717a7f2d2979dae67c7dfba9fb75c25755a6f4386af8e5af985bf8a5d70"
    sha256 cellar: :any_skip_relocation, ventura:        "23f98ff4c5be0c86bb435a1dc5a1b156c768ad36533140563377a18a53a4020f"
    sha256 cellar: :any_skip_relocation, monterey:       "6f6355268729a1dafb4f5ddb3242fdc3cddbeb4c918f019f867f81cb8c323091"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c39ba956279a59c935c7c6f6a17c42b98ea3f499070fae5d3db4d437dd801d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "985f305d89e797c9e24a67dacec4d01010993d7f16b39c36c6d1524a9f90aafb"
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
