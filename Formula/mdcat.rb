class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.19.0.tar.gz"
  sha256 "2e50dbb8f80b74dbed1cc69c731d8c782df35f2e968fc833b11640272d00f3cf"

  bottle do
    cellar :any_skip_relocation
    sha256 "a91f25b70cfc0b67f6e08f3eb5afb60feecd478531935429c72afa7d75e80e33" => :catalina
    sha256 "52e129aa30ad8cfaf78560ff4a80905b479569ba49f60c2bc45cac8660b17e36" => :mojave
    sha256 "ee40526c09883d4e0c4eda86ca22f6850da5cc9393c1498e1e5f4a30756b5e52" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

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
