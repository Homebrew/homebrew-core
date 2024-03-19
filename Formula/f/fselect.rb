class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/refs/tags/0.8.5.tar.gz"
  sha256 "e5742da80606630e310bb1567f2d72d7874f0b2537440e2800507abd786d912d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e9bbc875ba2f44e613054a3bc134784fdc7b6f18a60faaeeb140fe015e258ed1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2423d0fa3be3d4479878d2694d7ab2eb6dc33ae8288238cbec0a53f9b86dd5dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebff9cad196c45a6f2efb9b91fdba710b7d9581e4fc81ec426987420dac6c98c"
    sha256 cellar: :any_skip_relocation, sonoma:         "0362f97befe9ad9883a55debf2d0e4c036790d4969f5b94ff6befbde86fc91fc"
    sha256 cellar: :any_skip_relocation, ventura:        "955d5135ad508d76e6816b08bb0e92e425a6bd0322f621ba8cf67f7e3a57adcb"
    sha256 cellar: :any_skip_relocation, monterey:       "a5e0c53281c017ac9743c0ced5fe07bce3a4eed1a3660d0534e490cbee0d2f8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e1a9036f7623a859059bd501a0a7cd333e7b7206cd8e7a0d2be6e336a4f8be75"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch testpath/"test.txt"
    cmd = "#{bin}/fselect name from . where name = '*.txt'"
    assert_match "test.txt", shell_output(cmd).chomp
  end
end
