class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat.git",
    :tag      => "3.7.1",
    :revision => "521f83377ca85cf82853c985592ca5317ae9ee1e"

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
