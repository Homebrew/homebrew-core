class Gotify < Formula
  desc "Command-line interface for pushing messages to gotify/server"
  homepage "https://github.com/gotify/cli"
  url "https://github.com/gotify/cli/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "d33622db87549355b8ccc3d4a4e342cfc769fa96c45213e682b53a0971c8c41d"
  license "MIT"
  head "https://github.com/gotify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d41413c95f0690361e42655275578fe1bfca727c2f590e1cb46d30751b3f56d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d41413c95f0690361e42655275578fe1bfca727c2f590e1cb46d30751b3f56d5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d41413c95f0690361e42655275578fe1bfca727c2f590e1cb46d30751b3f56d5"
    sha256 cellar: :any_skip_relocation, sonoma:        "ebf635645387e72e4fc89c9028dbb1cb1349280b761748750aece59eb73b8640"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fbaf64b7affa2483a49f6e10fc0389a0ddda2797a2ddc57d66006270218e5680"
    sha256 cellar: :any,                 x86_64_linux:  "a51cb1c52b5c99b2373146265e91ef7f3c5a1ae3ea711b92d760d218f1bb56fc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.BuildDate=#{time.iso8601} -X main.Commit="
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gotify version")

    assert_match "token is not configured, run 'gotify init'",
      shell_output("#{bin}/gotify p test", 1)
  end
end
