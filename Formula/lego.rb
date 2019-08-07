class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego.git",
    :tag      => "v3.0.0",
    :revision => "e7a90b94711464ffbfd20e14cd180650ccc7103e"

  bottle do
    cellar :any_skip_relocation
    sha256 "53e588a893c476ac9929aa7becf44a99027cc0021d0bad83b79664f6dde9ec85" => :mojave
    sha256 "507137e4ea8c94ba5740467b7c0a57c77ce52b9b97c8bb1c3d443222f4df18ed" => :high_sierra
    sha256 "b23f213b07fad32d1b151a6e91f1a439c4f24f6eadaf3f384479793a25e9820c" => :sierra
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
