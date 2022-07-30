class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.2.5.tar.gz"
  sha256 "0446ff0698ebb46b02ebb5481f4ab954562d56361b01040e9d6c2b7e251ece64"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f706dadb02172d7cfae1308d8c096d3691d9fe508078d27621f058313486caa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43560eed110356fcbf8a81e30937b7c18fc45bdb24e3f8ca762c4ff5269d780a"
    sha256 cellar: :any_skip_relocation, monterey:       "6a37f01320f8e2b6d0072b0e39ce908a28096a89f3143e8a1dca65596536fa50"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ff8956f8d83c28b93254c63def30f7a251b2ac85aa1a02230a6b27a4c1291d5"
    sha256 cellar: :any_skip_relocation, catalina:       "b5ef5f12dc7f6ecf5768ae5f23610beb223d24673b81cfb5dd649b0e979ccc14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83fdedfabc5165d0ec4e420ef6ee78e68241e6a63f18781f126f076c49e0207d"
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
