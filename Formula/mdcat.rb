class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.13.0.tar.gz"
  sha256 "9528a0dedcb9db559c9973001787f474f87559366a2c7a2ff01148c5ab31eac1"

  bottle do
    cellar :any_skip_relocation
    sha256 "c00019af1facfd5e20ba4c7911119e4afdcab7373f2bfb1f36c59d43bb2e57e6" => :catalina
    sha256 "03a6092a5f1c29f6d603dcb70d65370df4c766636355c5ba4ad2eae5eb234c37" => :mojave
    sha256 "8eaebefd87230851d0c79f6b40076225a5a6051c176cd44173b04fa785fe7464" => :high_sierra
    sha256 "6f49eb3e6378bbcf315a0fece01f6eb67c2ba9166d60a6a2f15afe5efe1dabe9" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
