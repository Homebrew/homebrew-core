class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.13.0.tar.gz"
  sha256 "9528a0dedcb9db559c9973001787f474f87559366a2c7a2ff01148c5ab31eac1"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9d1828626a16a9be233143eff8d8abe7d2257157b929d62c307a5c3557ea0dd8" => :catalina
    sha256 "b7a0aa28deba05d9488d9717ba37a1da23ffff794ff7422332069d24f7731b13" => :mojave
    sha256 "24466bc6fb718df66d2c61b9a53d446e0bace8678b2ebb13fadb7caf4fde4da7" => :high_sierra
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
