class Algolia < Formula
  desc "CLI for Algolia"
  homepage "https://www.algolia.com/doc/tools/cli/get-started"
  url "https://github.com/algolia/cli/archive/refs/tags/v1.7.2.tar.gz"
  sha256 "0b7477c554c006de12fa936c9256c76361b3edd2a402b9be912efa61c4a1d400"
  license "MIT"
  head "https://github.com/algolia/cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8793143ba32c59eb92a56d6cb78810ac4ae5dce2e0d701f5eda245f72502043d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8793143ba32c59eb92a56d6cb78810ac4ae5dce2e0d701f5eda245f72502043d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8793143ba32c59eb92a56d6cb78810ac4ae5dce2e0d701f5eda245f72502043d"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcae2959e0157957a0c9812d800b642a8015e8ed8a63f854acdecf6b2e06b49b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bef97a8af4fd13535f8bfc8683cba135f15cd67e925c706b0a8df5289595acc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76fcee9eb35f5abf29950923a26587d84a5baecfbefd65a56872724c067221b0"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/algolia/cli/pkg/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/algolia"

    generate_completions_from_executable(bin/"algolia", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/algolia --version")

    output = shell_output("#{bin}/algolia apikeys list 2>&1", 4)
    assert_match "you have not configured your Application ID yet", output
  end
end
