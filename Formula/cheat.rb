class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat.git",
    :tag      => "3.0.4",
    :revision => "e7a1a296e3a4ba651dad3e461fc35db89a98225d"

  bottle do
    cellar :any_skip_relocation
    sha256 "c1ea3fe7f6d835172c20f8836aea19e3eed7274b651d5409de5d33ea53f948fb" => :catalina
    sha256 "d0b85eb4e05836fb2750b052ce67270f6e5a74dfa8e029f583f2f14205830c0b" => :mojave
    sha256 "a00d1caf21115340f529d5190b2b5b83e816e1ded62a092ae704550ebde28614" => :high_sierra
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
