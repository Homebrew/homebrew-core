class Duckscript < Formula
  desc "Simple, extendable and embeddable scripting language"
  homepage "https://sagiegurari.github.io/duckscript"
  url "https://github.com/sagiegurari/duckscript/archive/0.7.2.tar.gz"
  sha256 "c7640e8232f65ac208b0a0bc21d9b4b695087a3de96e94dd23c47bd37650b884"
  license "Apache-2.0"
  head "https://github.com/sagiegurari/duckscript.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea6f60db53df1104716d49e12559d5fee612dee3fd2bdbde4fae82c2972e5735" => :big_sur
    sha256 "b225f3f5c277f260b1cd19f7aeff3ea823b73ef77772b79480c8886fc82c9db1" => :arm64_big_sur
    sha256 "f2a4df37ab700852e3ceb13f32fc6067bd3ef619d9394b17f58398ad368911e4" => :catalina
    sha256 "5407dc856b08410b8ce096717bb4509bc91133c278ce7303e22bb7a339ab5f42" => :mojave
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
