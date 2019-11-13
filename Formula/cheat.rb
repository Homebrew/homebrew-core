class Cheat < Formula
  desc "Create and view interactive cheat sheets for *nix commands"
  homepage "https://github.com/cheat/cheat"
  url "https://github.com/cheat/cheat.git",
    :tag      => "3.0.7",
    :revision => "09c29a322f4393f1c92d00b84c867b2c8ff45a7a"

  bottle do
    cellar :any_skip_relocation
    sha256 "9484678d131ceff8d993b58be7b426fc4ae01c9d353b2ff8b85022fb3d008f70" => :catalina
    sha256 "213b1351d0d3416ab9adda329349a737f6cec0885abe16acf98268000c56939a" => :mojave
    sha256 "ed4d0cabdbfcc0ec90b672463079f27115f63efb08a0f30b73a62aad53e18e41" => :high_sierra
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
