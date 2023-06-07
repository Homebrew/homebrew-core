class Dockviz < Formula
  desc "Visualizing docker data"
  homepage "https://github.com/justone/dockviz"
  url "https://github.com/justone/dockviz.git",
      tag:      "v0.6.4",
      revision: "3ebdb75ed393d6f2eb0b38d83ee22d75c68f6524"
  license "Apache-2.0"
  head "https://github.com/justone/dockviz.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0cbe120e8493fc17a646efd6bbeb83afa33a4139afe331dbbd2fdf8a4c78a4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "156ba01d0f667ff0b607b53ca512ac44853d7ade5854f7101e9da9079eaf80ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12168679a5a86a9c4603bea3e4943b92acecc3078dad07c0dc780d036691c8e6"
    sha256 cellar: :any_skip_relocation, ventura:        "8df071372a3d9b63c113fe4834ae92107f24b19269901d04e6f717368c65380a"
    sha256 cellar: :any_skip_relocation, monterey:       "09de9aa1782b96c318d4e2965d565963880dce43fbc6dcca52a396c62f9a44d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "55392d3b7f022460d56c241b9cc9a382b6b97273ccaf2d94549e6ffd0cbf9a2e"
    sha256 cellar: :any_skip_relocation, catalina:       "ed054cbc368e35e27139571d63d390f626ff081f7bcff4c4b9ec2a73c9d19814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d00d55a57d1f8162f08e60ec07d7ac34e5ddc04e6865b09babf4072f4b52c513"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockviz --version")
  end
end
