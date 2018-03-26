class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.0.0.tar.gz"
  sha256 "93d9005905417c7eae0a7173aabb5c9c705a1024aff392c4d8f61fba9e71b039"
  head "https://github.com/segmentio/chamber.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8251becd25aaaddf8742d2e0253210ae5443f6bfff0a295d87c177819f9247a2" => :high_sierra
    sha256 "1b456146dabcbcbc05cfcef6621c737e071591a1d506239300b4a47bbc872adf" => :sierra
    sha256 "838ae965d593e089e44333ac289d60607d8b54ea6c68ae2c3db3e407e4b02c85" => :el_capitan
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

    cd buildpath/"src/github.com/segmentio/chamber" do
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
