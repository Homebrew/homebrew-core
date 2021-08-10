class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.10.2.tar.gz"
  sha256 "50e8bf541aac590a7eefbee7fe4d064a4bf23ddc8d83bbb81921f8b38c497299"
  license "MIT"
  head "https://github.com/segmentio/chamber.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(?:-ci\d)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "31f0d821fb9e59a7a952d39d609fe74287effe5c8ac615efabbad60ad41afc3b"
    sha256 cellar: :any_skip_relocation, big_sur:       "37c54803cedaf1e0c702503bc11f87d32fe14a492b723e96a018251b1afdcf75"
    sha256 cellar: :any_skip_relocation, catalina:      "3a7e09e668fb968d96558e7844cd4c236b1c5fe483401de44e0dbe42eb0eac11"
    sha256 cellar: :any_skip_relocation, mojave:        "9061f09b07a75474c1dcfbab79df1a6c63510c84f7dd7f0d2aec573e27c17eba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62f777d6fbe944f59565e31814b19187c2c65672a20f0cae1f6653b8e4cdb60f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=v#{version}", "-trimpath", "-o", bin/"chamber"
    prefix.install_metafiles
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
