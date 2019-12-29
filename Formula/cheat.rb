class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat.git",
    :tag      => "3.2.2",
    :revision => "f47b75edc0ef011d8955b1e2c522a74c8b6143e5"

  bottle do
    cellar :any_skip_relocation
    sha256 "321397ea3add121780d15c32a8072169c703cd3af7848e5fd3e65395d173df51" => :catalina
    sha256 "522ba4dca28c4bf7323ec7f79004cc28cd1564cd2f4c8e874776343c9f90c508" => :mojave
    sha256 "f9ca85aecc85a09842d4b96260167cbf565830981d1f8f7eeb47e74890a46a50" => :high_sierra
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
