class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat.git",
    :tag      => "3.0.3",
    :revision => "33ac3d34d129b40c41cd45ef0f51662646682180"

  bottle do
    cellar :any_skip_relocation
    sha256 "c9adb2d0bb7f37fb77f75b25b4c7a8361b7e565cac06c85518664d5701c6e9b1" => :catalina
    sha256 "16ce2dcf10c3969fe75291e96fc4f571f469af80634cfbdbe9784abbe1786bbf" => :mojave
    sha256 "0b95e89c04cf29d291d56e005286c9efb21277b10eada8975605d48245a9e5d1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/cheat/cheat"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-mod", "vendor", "-o", bin/"cheat", "./cmd/cheat"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cheat --version")

    output = shell_output("#{bin}/cheat --init 2>&1")
    assert_match "editor: vim", output

    assert_match "could not locate config file", shell_output("#{bin}/cheat tar 2>&1", 1)
  end
end
