class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.8.1.tar.gz"
  sha256 "1456dd9172903cd997e7ade6ba45b5937cfce023682a2ceb140201b608fbc628"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6c2ff7b692f810f1ba7bfd66c3b055aeaa58d474a886337507d1aa32440e7d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13083dd8d28582a15ac0a29e1fbd6ef53bf77c4c4e24036420fbf64e37713349"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "051fb86cb098caf6b5d0f2f297d123b6872327a35a17a264f7543bb352d755d7"
    sha256 cellar: :any_skip_relocation, ventura:        "1ed4c6c3be06957488680bb01d5a93d27c535bd15b49d7f817a457482a0d7b24"
    sha256 cellar: :any_skip_relocation, monterey:       "8e34b8b0bd29683f9f6f387ba74c1fc55212b03545967d9b47a68796c59fc6a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4355f2606b5c8560132195c0e23e04c88214c4a830816f219338acc608bd5a7e"
    sha256 cellar: :any_skip_relocation, catalina:       "27ff8d75002387f916d10e9ded0c9109622535dbb5709a2fed99cd8aa1bef1c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1dd18e5cf65db088171218366dd03661356f55b2be63df32342d8f48ec487f8"
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
