class Hyperfine < Formula
  desc "Command-line benchmarking tool"
  homepage "https://github.com/sharkdp/hyperfine"
  url "https://github.com/sharkdp/hyperfine/archive/v1.10.0.tar.gz"
  sha256 "b949d6c1a78e9c1c5a7bb6c241fcd51d6faf00bba5719cc312f57b5b301cc854"

  bottle do
    cellar :any_skip_relocation
    sha256 "0442a6f327081df37ce855d91fdf7bdf2136b8ef4f2039313274820936314c2f" => :catalina
    sha256 "4922076ae457efd2423a728e543fc2c3546f6e035f475e2f65b2cbcb977d2d38" => :mojave
    sha256 "d489a6d7cb337646e3f9954bc888cc8c6f42af5181ab6c0c4da51c65e8e5efa6" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/hyperfine 'sleep 0.3'")
    assert_match "Benchmark #1: sleep", output
  end
end
