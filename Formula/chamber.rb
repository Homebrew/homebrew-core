class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.5.0.tar.gz"
  sha256 "975d046eda38efc06c4fd77529612869d7cb76f35c6092b2a31f6000ec8fe9d1"
  head "https://github.com/segmentio/chamber.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0ea468454bbe3f97a52d4d5d6c0f0892030222902842682ae52498d2c3cd2627" => :mojave
    sha256 "e9c1c32c471e76fc4a3c4dc235988c53b24ca5e6a9ca3e1c35d10ffdd5172d04" => :high_sierra
    sha256 "0e153992bbdd6c4356ea2db2ea4844968d422205192ddbda0f1bd6a5431702c5" => :sierra
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
