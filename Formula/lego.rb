class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego.git",
    :tag      => "v3.0.2",
    :revision => "fd11248e65c1d04a7a9d3902438d244ad9eef598"

  bottle do
    cellar :any_skip_relocation
    sha256 "d56a127ab11c27f2eff19114c710000a6862535d2972580ae25311a243eb21ea" => :mojave
    sha256 "a1c491a2aedd0f383b61c56cb3c51cb93b3cec79ce97039c734b99c6cdbb17f1" => :high_sierra
    sha256 "bf993941dfc06dbfe345c25eb509cd184992cca09810eebfeb4a4687f1dbef7d" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath

    dir = buildpath/"src/github.com/go-acme/lego"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-ldflags", "-X main.version=#{version}",
          "-o", bin/"lego", "cmd/lego/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
