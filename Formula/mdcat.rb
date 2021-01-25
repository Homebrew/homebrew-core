class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.22.2.tar.gz"
  sha256 "92102c448c1742aa69604817d7d209c69ce1db5261cb6d8f0bb98cdc6c4f02f9"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "cd7462ead62dca44da914a890c0e16e4bc2e334b9973d99b47c77c8d23722a76" => :big_sur
    sha256 "874f6ef6565821c7ebccfaf032c0616e64c667214779f07fdb489f43c8499c73" => :arm64_big_sur
    sha256 "26cc236d7acf8ee17d2b9cf6b3e7f1ffa47c86d4b1abc40e1acd5ad418bc1c01" => :catalina
    sha256 "9aca864d6a18421d4daba029d9e8568c0bc1e8a3a3b51013c62b53237b4ba156" => :mojave
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
