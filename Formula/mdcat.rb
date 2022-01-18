class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.25.1.tar.gz"
  sha256 "97d789b1e95c90383a79bdf0167d71d3151c9b441e52f553829d0ba4c4cc4e32"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "135a0c42c2f1811d5b8adb6569eb5d172caf72dfbfe3a81573ce7c0d43004836"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79b83d8508ce17521c309247ede14e54e71baa7ba4e200e4ea79b8ead2a68749"
    sha256 cellar: :any_skip_relocation, monterey:       "ee3a03cb6a985ffb31a6df40e4363a8a2612393729ab385c5c11af471b7028f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef678c474b88f0bb4d480bbcd40502f7141003924e2f03218af0f4efbb287708"
    sha256 cellar: :any_skip_relocation, catalina:       "4cffac4f2f24130c060ae2e7c826cbadadebab39e74aff347b7fe0bf6474d926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb93a0d311bc60f3000822ace92bba233e0641c06ecce203d7ba7ee215c199c4"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
