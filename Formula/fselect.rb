class Fselect < Formula
  desc "Find files with SQL-like queries"
  homepage "https://github.com/jhspetersson/fselect"
  url "https://github.com/jhspetersson/fselect/archive/0.7.2.tar.gz"
  sha256 "8b2cbf8aff709ffcab49ed59330655669ab185a524e89a101141d80cc025063b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4126d38a8952a7e51d3c0f3c4481518ca5718611137f9c864955786c39651a12" => :big_sur
    sha256 "384f3df72b382a2c105461dc0f800e8f7afa84b37a0046f521a47519cf1f5dba" => :arm64_big_sur
    sha256 "368e4013f2a28775244c7758aea027e0809d6f9e676701ee386138cdefae9c94" => :catalina
    sha256 "b869be256a65037aafe9e474f57ab1310f60630bdf6a22004359035e8ec73868" => :mojave
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
