class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat.git",
    :tag      => "3.5.1",
    :revision => "7b4a268ebddedca7f94de7b1d9751212f68e3488"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f9e243008e7ee17a67c0639b4381fffbe15e73986885ba21e570c59c0a99b34" => :catalina
    sha256 "c7457982dc8bc2b5b47c5369696490a9b3537909e0653688b830d9453a0bb5dc" => :mojave
    sha256 "3eb8a81211128ed5959515edd9662b603a61b621e4f622f01f53b51c6ebcc3a5" => :high_sierra
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
