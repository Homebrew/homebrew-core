class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.10.0.tar.gz"
  sha256 "d5556a77f5c825fbc3dfd2e9974b3f14aaf8a244b3a903741035faf32892f11c"
  license "MIT"
  head "https://github.com/segmentio/chamber.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(?:-ci\d)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "434e7f69d1742843106b71893f7993917b6ae0e631eb5e176b7b6134a880eab6"
    sha256 cellar: :any_skip_relocation, big_sur:       "70c7daed2a2bc41ac6bfaf1d89d94dd24659f06d309542bbca667a5c8646444e"
    sha256 cellar: :any_skip_relocation, catalina:      "1280d86ef815339d4ed410b24aaacaaf02c7521acda2d303951103e8feba2289"
    sha256 cellar: :any_skip_relocation, mojave:        "700a24a9ba6adf62e377aa767fd80ad4c74d87eea4c136da2660bd2aa9575284"
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
