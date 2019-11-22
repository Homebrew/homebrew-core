class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat.git",
    :tag      => "3.2.0",
    :revision => "f86633ca1cbd3abdbce2042b3e8f9c2a4a9fd5a0"

  bottle do
    cellar :any_skip_relocation
    sha256 "487e2315487800539702b067e01462fd1201144fdaeb5ea9233280f377abab37" => :catalina
    sha256 "c711b3a1b833f5195b91e46592ab2e729f31315ea11aac55cbc52a50f4d34b77" => :mojave
    sha256 "415508d19027f9da22c99c5d927a2fe73fefe5e25ba471a22ad6b5010dd72627" => :high_sierra
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
