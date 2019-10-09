class Convox < Formula
  desc "Command-line interface for the Rack PaaS on AWS"
  homepage "https://convox.com/"
  url "https://github.com/convox/rack/archive/20191009130439.tar.gz"
  sha256 "43f3c0b874b586b7982bd27821c8e6d7e64d9d433b2caa05174f8f24dbaa53c9"

  bottle do
    cellar :any_skip_relocation
    sha256 "4a9f82d316a10d1bfa8f5918de84fabbb53bf22b1678ef534e118bc4a0027d7c" => :catalina
    sha256 "961ee6c3b422022d43b5a2c88887758458e6f6b8d0006749f20a10b6c0ffc570" => :mojave
    sha256 "31c288074b2c5328f65a9efbda63a4540fcbe2adffa180a4f431af963d962efd" => :high_sierra
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
