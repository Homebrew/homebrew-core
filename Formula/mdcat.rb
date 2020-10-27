class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.22.1.tar.gz"
  sha256 "b14846542fb8b60ac0235b399136372df7569aa59ed63f3faf88ff7a485abe5f"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8765ebb14e200949ef0cc2fa572aef8a84eea0c7b5b5b89ed6b8e2ee1896c4a1" => :catalina
    sha256 "3d46736eb02798a8d9dc986bcf025d89b3e5c19bc4bf0900eab9ea7c7aafb519" => :mojave
    sha256 "74d85385506c912257d520d7425ef9770cb7da76cd0edb1da1f4f22abeebaa2c" => :high_sierra
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
