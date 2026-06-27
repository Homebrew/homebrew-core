class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://github.com/unikraft/kraftkit/archive/refs/tags/v0.12.13.tar.gz"
  sha256 "be13ed7ba3e7d640075c3b8b34c6149209c17d67cdbe07d951612456a70f2bde"
  license "BSD-3-Clause"
  head "https://github.com/unikraft/kraftkit.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5734c5fe0827a7c016beb94f612e7e4b6d98e4c99ea953fd42319c991ba52d19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "884e4a62f40ebd26de51e88052b7aa347f0a2ab17ea639a55849410f0a939500"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25a39d438a2327d4e8065339866c994fb49ec830adae4357daa0bb6e72ecc667"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d7ca1800a455ff60530bd50d8d975c0c0de7868b91479e15c8a33d553874474"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3844345bee2029a4ef07742c69f412e1a35409271cf7f5358fedd34f86712974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "396d3c3fe402989dc2fb43199996113e8bbf5592fd97af24b4c5b70e297f04e4"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
      -s -w
      -X kraftkit.sh/internal/version.version=#{version}
      -X kraftkit.sh/internal/version.commit=#{tap.user}
      -X kraftkit.sh/internal/version.buildTime=#{time.iso8601}
    ]
    # Upstream suggested workaround for undefined: securejoin functions
    # Issue ref: https://github.com/unikraft/kraftkit/issues/2581
    tags = %w[
      containers_image_storage_stub containers_image_openpgp netgo osusergo
    ]
    system "go", "build", *std_go_args(ldflags:, tags:, output: bin/"kraft"), "./cmd/kraft"

    generate_completions_from_executable(bin/"kraft", shell_parameter_format: :cobra)
  end

  test do
    expected = "finding 1 unikraft.org/helloworld:latest"
    assert_match expected, shell_output("#{bin}/kraft run unikraft.org/helloworld:latest 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/kraft version")
  end
end
