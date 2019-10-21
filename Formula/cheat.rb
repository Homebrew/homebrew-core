class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat.git",
    :tag      => "3.0.1",
    :revision => "d19f0e1c5dcbef2d3852cff5d3f73ede1a204964"

  bottle do
    cellar :any_skip_relocation
    sha256 "af8476b088ecb10a559b4082bcbee85e30c243b1bca56860a2954e33cd4cbfd0" => :catalina
    sha256 "edc4911e3dc71c8307700c08aa1bd737146fc076842c250ad8d26de77c46d6dd" => :mojave
    sha256 "8fc5907164a0a1b4de27f7433e2908047dd743e8a34b9674f649e10db892c17c" => :high_sierra
    sha256 "1d585e8e457dec3245644177ce4b8716df1edca9a39fe958ebbb96be8917175b" => :sierra
  end

  depends_on "go" => :build

  patch do
    url "https://github.com/cheat/cheat/pull/486.patch?full_index=1"
    sha256 "ea7839da450d1f59850c880a2c972ca284fff004a52bb9e5d83d95355ae53c25"
  end

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
