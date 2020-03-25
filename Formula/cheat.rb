class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat/archive/3.8.0.tar.gz"
  sha256 "daa183b9328704bbd00fc423144ce29652b1750e895dbf9c99b131d98b7f01ec"

  bottle do
    cellar :any_skip_relocation
    sha256 "62c7190bb58281f301d23f3bd9f6db37bb2799ecebfe935bf7ad9482c494c6d7" => :catalina
    sha256 "ff3a82bf9be3490b71945349c844bb35a1243e8d147df08ad014a95777e80bef" => :mojave
    sha256 "3a65de1190334b11bc49afabbef1a8ded988ddf3610bc341494945845822cff1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"

    bash_completion.install "scripts/cheat.bash"
    fish_completion.install "scripts/cheat.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output
  end
end
