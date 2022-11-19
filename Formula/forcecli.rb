class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/v0.99.3.tar.gz"
  sha256 "4aeb530f4510b421b2d769e8e2f5b581f5e4613c5f58ec1e68273c2fa6f25d90"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e81ace3a525821052170f3bc9fdd13fc26d0cc6f9f80be7a38cf3bde2477aa32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2d8d5d68635e8c731b1f19a669fc8eddff71215d96a88b832cd6f13ec18bac1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "915f5c1e2f461d7f2dbe0fac79c325b4f9adc3207065380fdeaaffa8d1d2d8bf"
    sha256 cellar: :any_skip_relocation, monterey:       "3312d5b4027e154c734311b647184f7c1ea2b5b1d03cab810b228f55e245a734"
    sha256 cellar: :any_skip_relocation, big_sur:        "bae8d3f56049ce5e54cd51438d9960acfee03018cd687c22e399a253505449eb"
    sha256 cellar: :any_skip_relocation, catalina:       "00f2a3f3380e98453198bff54a554027379d9b3dee0c1cf5c6e76c0d3e05b799"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8748d3285184d69aaa4cdf80aa888791bf4861c8b767213832c03535787a27bb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"force")
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
