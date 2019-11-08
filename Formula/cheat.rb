class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat.git",
    :tag      => "3.0.6",
    :revision => "50dc3c8b29490f70ce67dfd426f681f5f5d01945"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e64a9406fedf9e8fbf1f6462985a0734a96a9c50d8822ae1e20faa4f5316063" => :catalina
    sha256 "c0c823c8c6635be3b0acc54b7149b1a1ead01282ec19ac51414efbc0ae8ddc7e" => :mojave
    sha256 "67316ce5e4ca0a35743100231d1c63919227d570e6b73c909e851f1000f89981" => :high_sierra
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
