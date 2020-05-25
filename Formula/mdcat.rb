class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.17.1.tar.gz"
  sha256 "f531447edf7a2433148af15f555f7771756c1cfa7d4c69684e09cb18ab9e89df"

  bottle do
    cellar :any_skip_relocation
    sha256 "b6081ece2ca84550848656d0e08ab604c28acf032f36852c20c38ab39a68d4b9" => :catalina
    sha256 "6a984d6e9dc81bfbb591e1fe5e158acebfd7d9e91f9f2f70eab6d4f39fd0bf44" => :mojave
    sha256 "f3ca8d4271f615d08b2ba53b6262611d7a101f56683d271a020876fb805f0d63" => :high_sierra
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
