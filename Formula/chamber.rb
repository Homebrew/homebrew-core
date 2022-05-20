class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.10.10.tar.gz"
  sha256 "5de6815e93a1126edfbd451f7696c67b13bf2fbe3148fa83083d98b1fd03fdad"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(?:-ci\d)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61d34418b064cb9644501f1491a4dd1153ced65c9f52bbcf414e65ec88bae439"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5a445855fcbb76b8ac45617d0f3812fbfcfc368ee65da68f66f2d5decb0ffd60"
    sha256 cellar: :any_skip_relocation, monterey:       "00314b585b4c8eaefd128a687057a7548581aedc5ac73e4a3d84e41cc2e619e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "abe15e8fc249b3dc843554cd9d1518ba0ce89e4c49be3d8171dd1712756b76fc"
    sha256 cellar: :any_skip_relocation, catalina:       "f1e73898fdb47b378627cf2ec25c313ff517a0a9f284f9f1284b5ca3abc6f2dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9899135eecebb39b35e7088e658be931dd5df7cdb9d38df9f77074b30ccec093"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

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
