class Kubefirst < Formula
  desc "GitOps Infrastructure & Application Delivery Platform for kubernetes"
  homepage "https://kubefirst.konstruct.io/docs/"
  url "https://github.com/konstructio/kubefirst/archive/refs/tags/v2.8.1.tar.gz"
  sha256 "3b8acebb3f314e365d16a74e9a3ea5e03b709ac6d289e403c162c11da4fad7d3"
  license "MIT"
  head "https://github.com/konstructio/kubefirst.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released, so it's necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c606e20b59e29281059bc744d674bfae73cd02596001d3979add9af3977780f2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f08a1b43face50d4a3bd991a548745e561d0c83233cedef511c60c7298f4fee4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3754a87615ddd1a770d709f259026cc4b148cbc23d152d99712100cfc428c27c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d11c871e52c0f1454d8779b042ca61c1e520a4eda8017af4b32cf3a7a5378f89"
    sha256 cellar: :any_skip_relocation, ventura:       "64579a6e5dfbac15eb61d1715ea8416a5c8ffd18f86ea560abe56d91ce9d77e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da6b913b8b6e7137d114b7c1abdc70d39b315d8f8a3a404cd45391b4da23cfe9"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/konstructio/kubefirst-api/configs.K1Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubefirst", "completion")
  end

  test do
    system bin/"kubefirst", "info"
    assert_match "k1-paths:", (testpath/".kubefirst").read
    assert_predicate testpath/".k1/logs", :exist?

    output = shell_output("#{bin}/kubefirst version")
    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      version.to_s
    end
    assert_match expected, output
  end
end
