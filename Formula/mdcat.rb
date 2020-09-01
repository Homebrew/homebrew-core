class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.21.1.tar.gz"
  sha256 "243fb64d72f4eee2350ab0db62c807b0e5092a4d39fb76f6d566c10687b723f1"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbf17b1fc94228608891ac25e5d801ccec34e30a0d3ee420fa6b4d5a33ca7511" => :catalina
    sha256 "792bbbc11b69fadf8d9b948cc554399e083c61d3b29f1f0f0ad338968214a366" => :mojave
    sha256 "053256e4dab07e2ba6c44d4a10cb6e40033a9a89e9affbd559a9346eeef7f906" => :high_sierra
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
