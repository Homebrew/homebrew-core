class Fclones < Formula
  desc "Efficient Duplicate File Finder"
  homepage "https://github.com/pkolaczk/fclones"
  url "https://github.com/pkolaczk/fclones/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "a548977699a13f2a584d318edbc46cb42f9f7e5badb645cb886389a9669fb734"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6720e5c7ce8bb7ac92c6c8c69e3eff16161969c80607536f0d2da49adcb60123"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5bed26e1886a6dd91167b033843bf8293add101a610c02e86852be34b271f4e"
    sha256 cellar: :any_skip_relocation, monterey:       "df585ccd39f0cfd7fa07a6a64112b35d82f6e335b5148f8bb41a7ce335e1e527"
    sha256 cellar: :any_skip_relocation, big_sur:        "78d896abbf2811286028c2c96fdc54df28875f4ee9ae5285d900dcf9354c46c3"
    sha256 cellar: :any_skip_relocation, catalina:       "8cbc3153daa05e58652128bf9ff5827915b4982a22ebff856634f7596ab2db11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "558bbd81f82f23217570725fce305c4463a2b4d2fd99d0f54bb50d8a40588462"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"foo1.txt").write "foo"
    (testpath/"foo2.txt").write "foo"
    (testpath/"foo3.txt").write "foo"
    (testpath/"bar1.txt").write "bar"
    (testpath/"bar2.txt").write "bar"
    output = shell_output("fclones group #{testpath}")
    assert_match "Redundant: 9 B (9 B) in 3 files", output
    assert_match "a9707ebb28a5cf556818ea23a0c7282c", output
    assert_match "16aa71f09f39417ecbc83ea81c90c4e7", output
  end
end
