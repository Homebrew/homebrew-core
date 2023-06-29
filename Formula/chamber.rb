class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.13.1.tar.gz"
  sha256 "dfded708e06cbb14403057824fa43ed2f8c6c119b0e63152a1cf17ff6edcc5ca"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(?:-ci\d)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83dc3cc4fbc21205a0f067f8f7777fd04364d6e1539f4fe8763b30041bc22060"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "83dc3cc4fbc21205a0f067f8f7777fd04364d6e1539f4fe8763b30041bc22060"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "83dc3cc4fbc21205a0f067f8f7777fd04364d6e1539f4fe8763b30041bc22060"
    sha256 cellar: :any_skip_relocation, ventura:        "67b185e92a9fec29a8fbbba4668dc3ffad9e726242d2c6ffa46f392b1ad68e8f"
    sha256 cellar: :any_skip_relocation, monterey:       "67b185e92a9fec29a8fbbba4668dc3ffad9e726242d2c6ffa46f392b1ad68e8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "67b185e92a9fec29a8fbbba4668dc3ffad9e726242d2c6ffa46f392b1ad68e8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "974908ac188c4b3006e9e7f21047cfb7d4fce2f49c5a5c7181ded4e33b443131"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
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
