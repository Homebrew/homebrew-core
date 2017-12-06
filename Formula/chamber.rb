class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v1.13.0.tar.gz"
  sha256 "72ae7b29a000750be5dd5e72658a912eba69d61d8b9055752e9720a2b2cdfaae"
  head "https://github.com/segmentio/chamber.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "07dbefd4249bee3fc6b47167fea6a8f542d526a260e219dcfecaa9665d2f1c2a" => :high_sierra
    sha256 "f5c42ea2733b1130bbb933295855bfe313cd14b5440687a40a047a3f17e2d800" => :sierra
    sha256 "e18f6cb06328115214cede8fd618c3e49d767fe6a18ed77a7246d14398cd6a21" => :el_capitan
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
