class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.4.0.tar.gz"
  sha256 "7387b529071fbc89944649d9a9b9cb1b919ca7288560cc96f428c0a77337e752"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d07fd60670f3fd4b0645820acead90edee4dc5024080d3988b504d62b794bfb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ef81cc46298cfa39fe4801052c728c97e447b6a692d107f76993d3121cb45888"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7b44aa761f35a07f75c14eec94bc1ccb3e4531aba3794a4fa376526344769a5"
    sha256 cellar: :any_skip_relocation, ventura:        "4e08789caab64d6fc1e714b48460509578f1886fa43d6a242c0e1217522646cd"
    sha256 cellar: :any_skip_relocation, monterey:       "cf4fd08cb067d65de1a76f265d65155f2c0ec5ccb85802a31ab4f80d58acb301"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b0935a128a3fd9042c121224da933059d5f69acb69e066546d53f831e0de645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a415fd572a75fe63edfff03cc2ce761409fca23ba9e88d466c775755ef77eb71"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "prql-compiler"), "--features", "cli"
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
