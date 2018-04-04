class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20180403021210.tar.gz"
  sha256 "dc60ca3ee80737a58b7639d34e6696fba807180be50bbe42df49bc7e4a152e1c"

  bottle do
    cellar :any_skip_relocation
    sha256 "3952bc97b388bef4c0e570e00e65cd9a5accb7b0a700afc6e9ff39e49ba6d02d" => :high_sierra
    sha256 "d42cf909dddc1a143180939964ff48ce4c35a944c6f39e2c84b354cd9135b44d" => :sierra
    sha256 "0eee7c1378d388801a3c761c9af2e81449e7aa580cf45bafd086f6e021dd8fd6" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/convox/rack").install Dir["*"]
    system "go", "build", "-ldflags=-X main.Version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
  end

  test do
    system bin/"convox"
  end
end
