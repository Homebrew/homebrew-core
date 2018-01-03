class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v1.15.0.tar.gz"
  sha256 "0f41f32449fc4cf69e26a349b6fd0e8b89dd2f79228e876b9edf8eaff4c4d4fd"
  head "https://github.com/segmentio/chamber.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cebdac72d8f08105673141cc7ac1024a7370c645d66d57da1b1d19db062ab8d5" => :high_sierra
    sha256 "623abf8ad84d1a9ad40bd9248fb3ee5e036de76ea34c97402dd767d5d73ab650" => :sierra
    sha256 "7e0c2b879e204d62a072746bf592aee2eb070e61b5c58795d3de0ea743e5858d" => :el_capitan
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
      system "go", "build", "-o", bin/"chamber"
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
