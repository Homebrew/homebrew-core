class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.1.0.tar.gz"
  sha256 "d28bf9d02f9477bf3339e750287d32ecbeaa2d1398411624074a4d4498e9693a"
  head "https://github.com/segmentio/chamber.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "5df3362da140d3d0471e876cc03b6b55fe00ccc1b87f5bdf72966969b775c088" => :high_sierra
    sha256 "8b21765d9cd894209134db5774fb1a3adbd760289b6914587387c7bdf0f96be6" => :sierra
    sha256 "b6abde35810a6c8ebfbb2d693bf939c0d5b368a2cb71b86fdd4e28d3b74c47a8" => :el_capitan
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
