class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.17.0.tar.gz"
  sha256 "bccbc4d80747aea61ecc3ffae17c5a14acbb0e80d485ca654c9d8261ceafe1da"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0ca453fe41c335d0f07c2f77bc27578051adc08c0a54aedbccc4516a4496a7b" => :catalina
    sha256 "7e4f234b6836d28d1f5b9c6343f9d9941f0035a7af1b2ba0ef35472353503d8f" => :mojave
    sha256 "751902ce6d2ecf346ffef9498a3f272abc0800cc1f4f2b97d8981eac409052ca" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
