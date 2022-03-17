class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.10.8.tar.gz"
  sha256 "3d6cd696438994c029e9ff6130baf8ea7fdd32aa17a4c9e88e5c4c05cbb71409"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(?:-ci\d)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1dda2eae145468749c30fd225fa89de47c0c127c51908205aee28dac29dac12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9afbea9c1aca36c0eb74dbf8dc62e27527e33032c14ea0b69291b2fe69b55c8"
    sha256 cellar: :any_skip_relocation, monterey:       "7b2fcf9c0067df0796c00042b13d9af86b117a2b51fffcbb82a4c6593aec7637"
    sha256 cellar: :any_skip_relocation, big_sur:        "e30892c59bade52f4b0bf18ab205f1d7fe98959f2d0431e714e78b45cb8d8543"
    sha256 cellar: :any_skip_relocation, catalina:       "6d7ea23b1690f3a9c290fb15f4b223f0604739bd463697b935e07a85dd0bf1c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5923595f91a382a8011156d13957538e329300d654098eeed7353b4622126976"
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
