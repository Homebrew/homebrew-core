class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20191216210003.tar.gz"
  sha256 "35955a9d79fcc7738442b295cc3df1e3859f80e1f0a6885ef666d8ba3adf0502"

  bottle do
    cellar :any_skip_relocation
    sha256 "d9ebc3153ce76d56f6108608e86db5cd6ff56d2d15a29f75057c02616ebeda69" => :catalina
    sha256 "defd7233bb6ba154e46997ebccf53ecef56d925548f52ada4abef131d086a6a1" => :mojave
    sha256 "aaf04a8bbcf4457ac4b943525b95ec642fda8192ffbc22eb08376d49070d974c" => :high_sierra
  end

  depends_on "go" => :build

  resource "packr" do
    url "https://github.com/gobuffalo/packr/archive/v2.0.1.tar.gz"
    sha256 "cc0488e99faeda4cf56631666175335e1cce021746972ce84b8a3083aa88622f"
  end

  def install
    ENV["GOPATH"] = buildpath

    (buildpath/"src/github.com/convox/rack").install Dir["*"]

    resource("packr").stage { system "go", "install", "./packr" }
    cd buildpath/"src/github.com/convox/rack" do
      system buildpath/"bin/packr"
    end

    system "go", "build", "-ldflags=-X main.version=#{version}",
           "-o", bin/"convox", "-v", "github.com/convox/rack/cmd/convox"
    prefix.install_metafiles
  end

  test do
    system bin/"convox"
  end
end
