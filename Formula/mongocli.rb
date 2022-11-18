class Mongocli < Formula
  desc "MongoDB CLI enables you to manage your MongoDB in the Cloud"
  homepage "https://github.com/mongodb/mongodb-atlas-cli"
  url "https://github.com/mongodb/mongodb-atlas-cli/archive/refs/tags/mongocli/v1.27.0.tar.gz"
  sha256 "cad2d02a8699d3cd621deb80439684db0c9b0697d1dcbfcc33a70c5772e49a9d"
  license "Apache-2.0"
  head "https://github.com/mongodb/mongodb-atlas-cli.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{^mongocli/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4dcdf86f13aba04f2d0bb66a2f0a590124e69c21e4704e1740fb353e37b30616"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e9bb7281818e642593bf01afe0fa04958bdf80788343dce24b400e8f2981001"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b041b70d391b572747107a67ccd2844e2867efb0970ecffa2de536dd27b4733"
    sha256 cellar: :any_skip_relocation, ventura:        "639918c5433da5b4fdbf155d1af2b205cfd03edeb968cc3ab673fcf2070560ef"
    sha256 cellar: :any_skip_relocation, monterey:       "3bef87280581006bdbeece7c5b7650f6113fa6b877cac545e65eb985a1f4c62a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e133e09dc0475370900c87f68fafcee7ad71b331feddbc617e9124afd1ad5b9e"
    sha256 cellar: :any_skip_relocation, catalina:       "43e17eedb6ea73eb0d940065e71ac8492e7de653ebcd0ceb32c754c9807b4d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "def71a082c0ac46e918a92a967aab8aac56a89fd24de2281506b05b5bea405d9"
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
