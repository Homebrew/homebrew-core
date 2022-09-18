class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.2.7.tar.gz"
  sha256 "955dde62493e9e58e9b06d80e6592f08b97c0d1cc701c3a9dc868f02e2f2f369"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31dbb40b0ca78f1af403149790deb0db05704b7890fc162d8b7e5f6e118bbd5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "774fb758905e3b1fb48cbb279b412eb81b9bc61efc607de2711e2bdc728e584e"
    sha256 cellar: :any_skip_relocation, monterey:       "993080157b0e7ddd3140ac95a70994dd393f09f3c8f5072bdc7d3f233b21d7d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c4eec55bb2ad1b3c80d7b38d6fe3e64b8566cecd1c2dcf01313afef94e52df5"
    sha256 cellar: :any_skip_relocation, catalina:       "289e483f97d21e4dd94c88ab33274a98cc3db2be5653f7e3fe541ad6786a6116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d942a8c7d71ec638a4d56ae13b9d48d22a72647b3ca3f4e51e659e16fce1fccd"
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
