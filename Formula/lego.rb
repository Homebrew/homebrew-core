class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego.git",
    :tag      => "v3.0.2",
    :revision => "fd11248e65c1d04a7a9d3902438d244ad9eef598"

  bottle do
    cellar :any_skip_relocation
    sha256 "23d2d506cd55a4d0877505a5ad591d348d55751e8b2f640a6914e601f622e478" => :mojave
    sha256 "551e3b918f7f4086a0a190f714a600c52239bfe6b08edbb000fdc9c2c62b0a58" => :high_sierra
    sha256 "5a2b29458d92738e19cc8fc7f8ab858bff1be84b29fee3e7e6d76725a004eb6c" => :sierra
  end

  depends_on "go" => :build

  def install
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
