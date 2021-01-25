class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.9.1.tar.gz"
  sha256 "184f5fe1e7a6892434d8a3f12f200f3b0fb2d77699de07e9f0a09a38f3a8297c"
  license "MIT"
  head "https://github.com/segmentio/chamber.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(?:-ci\d)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f98f49f41294353f97828a2a70b5ea06fb3ec1f4bda4b73326bc579d50824504" => :big_sur
    sha256 "487000d226226ddd1f020448fcdd47b4cdd292ee2fd08d24841e04f42bb14516" => :arm64_big_sur
    sha256 "fca35a9b426e21b6e11eced77d39737127ad6f74612de786093caaae8d7a49c3" => :catalina
    sha256 "147cd21071aab8dd7a305d2071afe5ad55b80879e48178b5274c9b5bce0ec41b" => :mojave
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
