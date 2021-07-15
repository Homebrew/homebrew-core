class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.23.1.tar.gz"
  sha256 "0254f2611df58a320057dd467b6925eb2ddc5dfc163f298fa57099f50bacbde1"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f0c38e191e483f390a9b7324adf7a17e9ab5902b7db7bbff16c780c2a6583dec"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6a1be8b27f8493192d3fc600e5796ef216fd5fc37d6f9a71b08656d63b3d088"
    sha256 cellar: :any_skip_relocation, catalina:      "0841c94bc8910a3f45de9ca4a19b2354d00124ab1dfed9770adc6c7774e0cef5"
    sha256 cellar: :any_skip_relocation, mojave:        "07cc85499ea9c642b08166404933bdaf19c8fd9730e6437b800be9a3f1cf8d1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0680c656186b15cca3033b6b4937f59000b59199de3cc432cc844401ea08af2"
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
