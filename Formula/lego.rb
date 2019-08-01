class Lego < Formula
  desc "Let's Encrypt client"
  homepage "https://go-acme.github.io/lego/"
  url "https://github.com/go-acme/lego/archive/v2.7.2.tar.gz"
  sha256 "eb585fe8cd23671bea4b09c8f03d7a331f5b734aa652210f8cec897a6d6b8dbc"

  bottle do
    cellar :any_skip_relocation
    sha256 "53e588a893c476ac9929aa7becf44a99027cc0021d0bad83b79664f6dde9ec85" => :mojave
    sha256 "507137e4ea8c94ba5740467b7c0a57c77ce52b9b97c8bb1c3d443222f4df18ed" => :high_sierra
    sha256 "b23f213b07fad32d1b151a6e91f1a439c4f24f6eadaf3f384479793a25e9820c" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/go-acme/lego").install buildpath.children
    cd "src/github.com/go-acme/lego/cmd/lego" do
      system "go", "build", "-o", bin/"lego", "-ldflags",
             "-X main.version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lego -v")
  end
end
