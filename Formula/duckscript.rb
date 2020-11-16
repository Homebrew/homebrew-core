class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.6.9.tar.gz"
  sha256 "68439037eae207cd3258273336e74b8f19a801b5124df6fe6cbf7f016cb74ee0"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb08bf552b2bdb53a80986ecca06bcc11013af4948bcb667b4418b952faa4359" => :big_sur
    sha256 "d2ac775f2fb43ed0332b5a71d0315a1397b16a2e9b57b26c1540593957f6181b" => :catalina
    sha256 "ba552704c9c91548ceb96498cce1c7f0af4c2785f90a12b8e4e99d35d068e80d" => :mojave
    sha256 "b8afd62072875d773f11edfa79c1fd478957d5879743758b3a16fbf46a66df1f" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    cd "duckscript_cli" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"hello.ds").write <<~EOS
      out = set "Hello World"
      echo The out variable holds the value: ${out}
    EOS
    output = shell_output("#{bin}/duck hello.ds")
    assert_match "The out variable holds the value: Hello World", output
  end
end
