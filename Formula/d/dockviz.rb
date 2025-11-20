class Dockviz < Formula
  desc "Visualizing docker data"
  homepage "https://github.com/justone/dockviz"
  url "https://github.com/justone/dockviz/archive/refs/tags/v0.6.4.tar.gz"
  sha256 "228e2c11fad1de38ec63e5d46e60bf9411625447c3c381dd0cd99aaa05d4e5db"
  license "Apache-2.0"
  head "https://github.com/justone/dockviz.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "9c805f7312b7c483e83d459b1e6a724d3e2e4940c416444dfd8ee7a79a5ea049"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "4a1770a99278e7fa43efce29515eefb0ae70d895590503b3ba4e13fbfcc27a3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1081dedcb9f5e575615a345d55b389cb61f1f5208745fa387d6cba861a06b525"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0cbe120e8493fc17a646efd6bbeb83afa33a4139afe331dbbd2fdf8a4c78a4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "156ba01d0f667ff0b607b53ca512ac44853d7ade5854f7101e9da9079eaf80ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12168679a5a86a9c4603bea3e4943b92acecc3078dad07c0dc780d036691c8e6"
    sha256 cellar: :any_skip_relocation, sonoma:         "20d50dc20e32af765e4164d2038618ea107a83e92962339d4bc3febd703687d8"
    sha256 cellar: :any_skip_relocation, ventura:        "8df071372a3d9b63c113fe4834ae92107f24b19269901d04e6f717368c65380a"
    sha256 cellar: :any_skip_relocation, monterey:       "09de9aa1782b96c318d4e2965d565963880dce43fbc6dcca52a396c62f9a44d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "55392d3b7f022460d56c241b9cc9a382b6b97273ccaf2d94549e6ffd0cbf9a2e"
    sha256 cellar: :any_skip_relocation, catalina:       "ed054cbc368e35e27139571d63d390f626ff081f7bcff4c4b9ec2a73c9d19814"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b4ef5dc4b07e8a8cea9572fa24d13234d5fa45f1f07f72b8296fbf857d1544eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d00d55a57d1f8162f08e60ec07d7ac34e5ddc04e6865b09babf4072f4b52c513"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockviz --version")
  end
end
