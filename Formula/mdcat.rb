class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.12.1.tar.gz"
  sha256 "7722ac648e2e0ac99084b636b63c5e15ab9ed6666d1ab543117f8b93b715596e"

  bottle do
    sha256 "9f5e1a3b8d45d4a039af703b8fc2cdaa08f8548e03d13a7089db98a6debf1f32" => :mojave
    sha256 "0d18d43a77df89848b34a3b8b524d6c439f77a1ffaacc1a96f580ec907729aef" => :high_sierra
    sha256 "e7c7d8356e72c60d869da954001a45ff0b06fa017af1b1d77266c6d09ac91750" => :sierra
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
