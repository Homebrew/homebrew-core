class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.6.5.tar.gz"
  sha256 "5f80ec08476591697bc6c777452b6ab6f7c3700b2d0606384bf2b0f4090a9a8e"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "00a4e4455a407edd5a85d66845ef84279f15da34551551624119fa9fa724adac" => :catalina
    sha256 "5a6f1da284a7c00ab22fc72e5a69eeac5247b28b99eaf1e8eee683491cdc1e46" => :mojave
    sha256 "255f427810a410144fb306aefd84a6d0f8161ffba4c2029565415390773101fc" => :high_sierra
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
