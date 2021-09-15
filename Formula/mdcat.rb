class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.23.2.tar.gz"
  sha256 "354f1bea0a53c5547693b7de9731d6e2648a0da10aa485ca16e4e643e49be14c"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "503b07b77a2c463c8f91f2c5aba413e9723e1d4cc78fb90cd15809f3f0e7ca2c"
    sha256 cellar: :any_skip_relocation, big_sur:       "a702508fd962f1575bdc81680d43da1933d405a147112675b6c2c0a1a55ed335"
    sha256 cellar: :any_skip_relocation, catalina:      "f03d80008eff5ed3598e8eaa3c10be5446ae6737ac4b69af10d45aca58619e3c"
    sha256 cellar: :any_skip_relocation, mojave:        "3ca1ba76b588574866268d2a624954b8d31c89804d30d00a0fb4e81f86fe1be7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d927a87695d61b281e1d8449d22614124bdcc18beddce97c244e5bb856a755df"
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
