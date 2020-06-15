class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.18.4.tar.gz"
  sha256 "ecb4085e7687376d87fb2564ee73c2cfe4566787533731b2d81b1973c78f1aa8"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c7ffbfe79e0dff7e050399c9c18d799de9f7e92571062ef889e2a38a2548c1c" => :catalina
    sha256 "0a7218b021e223e4e502c6e5b4563e6666f9e57d7a6e676795719cc4704ad12d" => :mojave
    sha256 "b911b901adb34338104b363d06ea0286dfe8a1e132e053351bfdf5c2c7fc991c" => :high_sierra
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
