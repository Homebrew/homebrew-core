class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat.git",
    :tag      => "3.2.2",
    :revision => "f47b75edc0ef011d8955b1e2c522a74c8b6143e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "b02352aed34fe7f2ba8a119677bb24164e1fe2ca4479f3221abdd34f864b2297" => :catalina
    sha256 "d9fd5fd5aa32cda93946533d76e250a46bb3a880b3174282d8977ff27048388e" => :mojave
    sha256 "a49311e865e5b7c6d8e3718fd4f0ecf07d245008e68e2bda376482c731b98c30" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output

    assert_match "could not locate config file", shell_output("#{bin}/cheat tar 2>&1", 1)
  end
end
