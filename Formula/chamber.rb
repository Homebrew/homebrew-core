class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.10.9.tar.gz"
  sha256 "4c78a56bd99258335b9ecb1ca70eaa4d7a7b0956463130ecb395ac9301f68f82"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(?:-ci\d)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eec0d31c6a4fdab5b0b9384ec71164c7d04ea9e7706fc9e84bbce3b62965aece"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7aaa766f6979cae9ac33c2bfdfc37d7726571d3d01751393c8daddaad1403c65"
    sha256 cellar: :any_skip_relocation, monterey:       "ac701c622677dd49db0e6a22eace1070b5be60160cd0dc8a6284bf61b3e03c2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fdb7ceffa9c3a5138048d54994d2a26b5ae7730d05b2ba4fbf08aea4e210504"
    sha256 cellar: :any_skip_relocation, catalina:       "629629013182f6fccbd00d016a23b3a3108813d847c70be9157055a5c28cb31a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c10549c09b1ed92ef1a9a281d9597bae08781e04624874ce5aa2b36b710a8d8f"
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
