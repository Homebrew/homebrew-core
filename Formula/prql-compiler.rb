class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.2.6.tar.gz"
  sha256 "4079d5f505250e6fe071215499b21e8ac7ecea23b55a16a4054bc5bf5707faf6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f6c18de881fa5a79d71a39d3ddb2ba213a319250efa202776714e3a71115136c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1bf112635d3a6376522fee4301765b86b8e523178579f7829426db59ad998098"
    sha256 cellar: :any_skip_relocation, monterey:       "8290a090f7cc180d8f67072d31783407693836406b759c22914baf02757869e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb16a09401ed22e58b0217019d41a52d1936e50da669bf3385c908c79141a3d7"
    sha256 cellar: :any_skip_relocation, catalina:       "76dd3c32e8a9afe0e20cdecebbad0aa779986ef485f5777c3b0d82181bee65bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "94136b5e2eb88017984c1e52b4a6a97158d4719d0fa5ea27075db09c7ceb9277"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "prql-compiler")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prql-compiler compile", stdin)
    assert_match "SELECT", stdout
  end
end
