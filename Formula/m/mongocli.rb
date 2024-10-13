class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://www.mongodb.com/docs/mongocli/stable/"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/mongocli/v2.0.2.tar.gz"
  sha256 "3684d32de193b0607b3da9f0bc0aec1a9854311593a97bbf5763d79e43ff81d3"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "mongocli-master"

  livecheck do
    url :stable
    regex(%r{^mongocli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78179f8700723c0d4b856970c40e088556dffa8eeec829b639db74c5152ce53b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cfeefd60b5b7c826cd3a13bbd0bc18247b355c3cfe421f927ef3cde9ae9b4684"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "55e8e3ddc0484ccecec676dece4ae0396e6a57dfd04038a41eaf1e562ad70d71"
    sha256 cellar: :any_skip_relocation, sonoma:        "2e9b8c26b860d123115fbae9521e944c18dcbdea2d9d179e3c796cacbe1a3eb0"
    sha256 cellar: :any_skip_relocation, ventura:       "7bb9f499d6d32329a6022be3b21082d0594ee93efd266f93432226efc93b7234"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88c2093ce67ff924d08962e655f40407409ae3cacb1cf568dd7635101cb18b73"
  end

  depends_on "go" => :build

  def install
    with_env(
      MCLI_VERSION: version.to_s,
      MCLI_GIT_SHA: "homebrew-release",
    ) do
      system "make", "build"
    end
    bin.install "bin/mongocli"

    generate_completions_from_executable(bin/"mongocli", "completion")
  end

  test do
    assert_match "mongocli version: #{version}", shell_output("#{bin}/mongocli --version")
    assert_match "Error: this action requires authentication", shell_output("#{bin}/mongocli iam projects ls 2>&1", 1)
    assert_match "PROFILE NAME", shell_output("#{bin}/mongocli config ls")
  end
end
