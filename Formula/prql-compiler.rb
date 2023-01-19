class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.4.1.tar.gz"
  sha256 "b60df362a0b823600ccc614c335f4a8876a577a7ceeb6d162f16540fd9340f73"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b7424fe736ef2fd15f5e67a76b6576bac3e7930adba598c9dadba939ad915b9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56cc9833b457c187014dce5adc9ff212987a983b88089b608ad58f06d43bd5d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7190ec9bf9c2c060d3864278171fd7ca3406d58505d88057edc9c1c11f02b529"
    sha256 cellar: :any_skip_relocation, ventura:        "cac3ad853cd4575e9e4711a5a9e9541e5802b48dd717ae0fdbdb6737a8872a54"
    sha256 cellar: :any_skip_relocation, monterey:       "d93a32516573867316e32d973f77eca392c7e194cbb5b17a0674195e8adebb2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "eeb82dd2a0ba3dd1082dbcc90500e174cadcfe71e84d498c05fbd45bd242611c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9da8a68182ce95b628532794dc3167fb5e2e5c7b773f9456229b6bd56f7da2d"
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
