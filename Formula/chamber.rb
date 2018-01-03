class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v1.15.0.tar.gz"
  sha256 "0f41f32449fc4cf69e26a349b6fd0e8b89dd2f79228e876b9edf8eaff4c4d4fd"
  head "https://github.com/segmentio/chamber.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e459173f631ea322955ef9d7d5475218583cb58297d80b06ecf5fc1985a4285c" => :high_sierra
    sha256 "e620b2070209281cef99c5b92a6b567c414a5886145d65d871601aae12196e47" => :sierra
    sha256 "677a0042b9d2806b9e826cbfcc82fc8d5f36b0c4283fe6665b3d63efe6ee54d2" => :el_capitan
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
