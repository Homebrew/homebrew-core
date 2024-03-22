class Pylyzer < Formula
  desc "Fast static code analyzer & language server for Python"
  homepage "https://github.com/mtshiba/pylyzer"
  url "https://github.com/mtshiba/pylyzer/archive/refs/tags/v0.0.51.tar.gz"
  sha256 "23e9486f08165187b67e7ca11cbbeeeb16c2f8c1993f7e1724ce60f702d0c448"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "120a0b5ea0e939e96045e1d6fb653a494c4b35779327670218384aaf75947d6d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ab7994d5882a74e6227c9492d9f89f481cc116bd15085b701d92c15e44b0880b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f6019c5112bb09c34b47b51150e22cf8238e55bd9dbf59ac513c0d9f0b50b7e"
    sha256 cellar: :any_skip_relocation, sonoma:         "2fe727daa14144f58c909986250ab6030707856225d9b3aca6f24e4535f94b40"
    sha256 cellar: :any_skip_relocation, ventura:        "1a5613423f296b9e9ce3e9dd804a4d148fcdbd0ad741e997d5808436175e3f14"
    sha256 cellar: :any_skip_relocation, monterey:       "40d8f4819d44bf3e8c1d89f80c9930a016df33c281f73b9d330cbc92704cd8a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23dcf64dfd939279a8f934946e976d5befe7ac067ee43c784e82f64e0dcfbc2c"
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
    (testpath/"test.py").write <<~EOS
      print("test")
    EOS

    expected = <<~EOS
      \e[94mStart checking\e[m: test.py
      \e[92mAll checks OK\e[m: test.py
    EOS

    assert_equal expected, shell_output("#{bin}/pylyzer #{testpath}/test.py")

    assert_match "pylyzer #{version}", shell_output("#{bin}/pylyzer --version")
  end
end
