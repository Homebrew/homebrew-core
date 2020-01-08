class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.14.0.tar.gz"
  sha256 "330059534642bba502e82d6a86f16451b7ce9d2ad02e356fd0bcff961020bc9f"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f429b5c3439c9cf41671a6967221b13cbc14f5cf419015835ccb4f199a877de" => :catalina
    sha256 "3717ce4c47ef8073aae8c120b9b13370b4dd5d057fb905702509c5e6bb4cbf46" => :mojave
    sha256 "5b5a9b299693ba6484ad935420c5b5c2f311b9867dfd9dceed161e168553a9fb" => :high_sierra
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
