class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.7.0.tar.gz"
  sha256 "56c14520fa2e30dfefdf4191222b4d907a1a404ee2dfcf197daef98bd16d88e4"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "95a0fe29b1907c7a470c7438cf09d4dabad782bbc7c044bc6852a93419d593a3" => :big_sur
    sha256 "504bd5561e0e1bc0411224626b1dcbd5d5cc5c12bcf376fa375db44406c3fb31" => :catalina
    sha256 "e46bb4319996bc3eefa666cd34df09f5397c418291ae9727f166720a969526fe" => :mojave
    sha256 "ab1c0687f2ec303561547349e21342c8eeb9d38c64f59e1c63ebc50f8601fc2a" => :high_sierra
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
