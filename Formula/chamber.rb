class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.10.12.tar.gz"
  sha256 "7766ef7f84b8fe09aaad13b5bbe2256b05fd1e44cac6279de5051ecfb9cc5c66"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(?:-ci\d)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a138a2818f0e8654d7a037c47b26d04afe5fcca218202a8d22036bb663d9ba0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c9474f3c3f88813e4b7bb293039eef43468a31baefbcd84ef22e112b5b38577"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1ef203eeb0029032c383d8ef18ee5847dde0260975004fdcb7e58f139b9e671"
    sha256 cellar: :any_skip_relocation, ventura:        "2463b7d0839030cbd72e680c89a2d3efbdda2c8282176f1ed4c4b11abf1ed86f"
    sha256 cellar: :any_skip_relocation, monterey:       "63110436d09c64179e12ef7e4a441bb8aa09c688776a5fdcec216d8e878a1a84"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f6801db19ecdc06231eecfcda28c8f36f4b94714f4d2ad8fb9510aeb1c93b21"
    sha256 cellar: :any_skip_relocation, catalina:       "1909ef937908a3ce510de1a56336e95c47115989caa5ada6705b983b6b303a51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69baa13bd656719221bd2673882deb3035e274fa7c07c096a58f2b76aee6bd56"
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
