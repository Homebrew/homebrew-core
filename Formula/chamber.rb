class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v1.9.0.tar.gz"
  sha256 "098568ddda04956b8dc270aa8e6b4eb83d8cfe92add8ea0172715eab7db050cb"
  head "https://github.com/segmentio/chamber.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "acecb58aaaadd6887644359150a8ac8ed094c69b3e7d8025a5381f4eb3c0471b" => :high_sierra
    sha256 "ec834deb9e30e9cbe648dea1fec3eeade4cbb51cb45247be49827438984cc6f4" => :sierra
    sha256 "5f481ee9d65657e9df8426f2d1e8f78195120fdbf7db7b9a0f7f3971815d9530" => :el_capitan
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
