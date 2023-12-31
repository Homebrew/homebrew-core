class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/refs/tags/v2.13.6.tar.gz"
  sha256 "53c346fa3b4f59519d710b06e725bbc272cfc00f1d7d6e33508f93839f03d432"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+(?:-ci\d)?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d324776b53bb6630d0731821ea6dadc6df77c37b207c7f390607c7932e742c1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ad93d5f07f05da398bc3a845dff5a03895fdb31829dfa2c24ebe0a8e65d12d5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9d0a8d5846e93a8ccd0d36a18a414bec308a9c671edd3842378251944bcbba4"
    sha256 cellar: :any_skip_relocation, sonoma:         "d1ca72b4b0f131256631666c9c2fce4d245d86847b929bc5bea14ea4b0109bb1"
    sha256 cellar: :any_skip_relocation, ventura:        "62c890d37a64f0ec716e328571e6e4c46c10d95e0662c62251e8e0d1875bbc73"
    sha256 cellar: :any_skip_relocation, monterey:       "d1ca4fd662872b6c45fe5d5031fd7d9c5cd8cf2046e9d39fe3bd7cd872b27d03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b270dbf03e54c841fe00d2c9b31a5bae36c063160d345cebd97d133d22a2346"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=v#{version}")
    generate_completions_from_executable(bin/"chamber", "completion")
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
