class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.77.tar.gz"
  sha256 "97537fdd2cdf96985f36064d19a56560289b742587462b7992fa663578ed0cbf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84c642085003eead22959ac964b03502ad666bdef27cb45ee3a5b044efffdd55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c4b64e957756d19118e32fe099e002bc9fc05373cac1a04cb44ff94af63c8f2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "524d0ca0faab4a47b5dfe67ee48f55b706796c7714dd4f4cbc45ff046c3db902"
    sha256 cellar: :any_skip_relocation, sonoma:        "43b1524b6ee6ea35d04ae86e932d538de9612c0461aabf830f0fd842d777fef5"
    sha256 cellar: :any_skip_relocation, ventura:       "0c755b00a7de0bee2c1b0681a3bca888fecf1f800c37a62b91e40be3b3cc3787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5007227ff60025afaeeb6195117f2d86afde61be00c3e1c99c6270a3c07e5c08"
  end

  depends_on "rust" => :build

  def install
    ENV["HOME"] = buildpath # The build will write to HOME/.erg
    system "cargo", "install", *std_cargo_args(root: libexec)
    erg_path = libexec/"erg"
    erg_path.install Dir[buildpath/".erg/*"]
    (bin/"pylyzer").write_env_script(libexec/"bin/pylyzer", ERG_PATH: erg_path)
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      print("test")
    PYTHON

    expected = <<~EOS
      \e[94mStart checking\e[m: test.py
      \e[92mAll checks OK\e[m: test.py
    EOS

    assert_equal expected, shell_output("#{bin}/pylyzer #{testpath}/test.py")

    assert_match "pylyzer #{version}", shell_output("#{bin}/pylyzer --version")
  end
end
