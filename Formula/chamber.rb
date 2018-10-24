class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.2.0.tar.gz"
  sha256 "5f6830e93b55c4043fba819518eeaca51990480bcec024b306be58fb99d083bd"
  head "https://github.com/segmentio/chamber.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3db97b755c45688c77aacb58ada7c52008da8f3305ee8115fb9c0d64ebefe344" => :mojave
    sha256 "c9b47bb3e900fbe89de70a102e851377a3d3efcaa8383712927108589e8ff075" => :high_sierra
    sha256 "88cae1a0bc2c96fdbd9cbcedc872a8768f9d2972d653bd963d672c36d47285e2" => :sierra
  end

  depends_on "go" => :build
  depends_on "govendor" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = "amd64"
    ENV["CGO_ENABLED"] = "0"

    path = buildpath/"src/github.com/segmentio/chamber"
    path.install Dir["{*,.git}"]

    cd "src/github.com/segmentio/chamber" do
      system "govendor", "sync"
      system "go", "build", "-o", bin/"chamber",
                   "-ldflags", "-X main.Version=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    ENV.delete "AWS_REGION"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "MissingRegion", output

    ENV["AWS_REGION"] = "us-west-2"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "NoCredentialProviders", output
  end
end
