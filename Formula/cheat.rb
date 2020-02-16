class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat.git",
    :tag      => "3.6.0",
    :revision => "b13246978ab7ebb254b49d58c625f94aa2e08ee7"

  bottle do
    cellar :any_skip_relocation
    sha256 "5b5659889c08fe22d962c955804c210a508cc5ba4cefa69d81076c81d55c63b9" => :catalina
    sha256 "1165dcff4c53fdb3adc322101373d2ada3f4eaeced8a133e982377055ed8c57b" => :mojave
    sha256 "8160f43431907f2d7aed7a9a527b5f4c5760c67eeeb788deb2196396ab297a55" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output

    assert_match "Created config file", shell_output("#{bin}/cheat tar 2>&1")
  end
end
