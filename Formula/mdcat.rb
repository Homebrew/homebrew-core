class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.25.0.tar.gz"
  sha256 "92fddabab24f2e7d673b06c1f31a7746abbb547c5581faaed17a8e3e1e5b17a5"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7cf9e3a6c820001d2fee081d0692af92b3d3914dcbe014066435a21399347e7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5866969c2cb5f980e5aca15705777910c191ec4776bf8f66130f5c0ded0dc665"
    sha256 cellar: :any_skip_relocation, monterey:       "67ec115b2c2339f137f90fd6071261f3a06e309f33a32ee90dc279337bcd1006"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab32369da90897622719adc11f79f1612173362a631ae667021989dfccda15b1"
    sha256 cellar: :any_skip_relocation, catalina:       "c0a107b3f597dd9e0777f1f91a4bfec4fd9cf06775d9dfa40f833c5654f667d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "900aa2913e2dd8193f44930fa01fe48e3c48a66a690f4886d7165c44b9d5fa12"
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
