class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.15.0.tar.gz"
  sha256 "91b5abff3e525df4f97f2677b0d099a79ea3dd0037fcdf11aad8886403f922ae"

  bottle do
    cellar :any_skip_relocation
    sha256 "be8eedc0fd6900ffaaaf1bca43928cfa14fc35443b112494c308270dd63ec940" => :catalina
    sha256 "7f0c907a382e09c8429da319b004bb7f9bffc56d14ed54b3c0b012308f422d22" => :mojave
    sha256 "005938f60dc3aec1ab83fbb9e8cc843fe4ea20f874a59ba20b047b3b37290083" => :high_sierra
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
