class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://github.com/unikraft/kraftkit/archive/refs/tags/v0.12.16.tar.gz"
  sha256 "a7d26ba2a73583e0aaa5e027a09bf583b080cb2e60ccaba10e7a445eafd4fa22"
  license "BSD-3-Clause"
  head "https://github.com/unikraft/kraftkit.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0d30d4213a127ad7364729919f1087cbc2e53251c518bbdfa18b1bb2742e5b3e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ecdddad3c09b5e367ed20710bde93aa50810a2004f838d6447c4a6b7a2593296"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1d0bc52463333ea227538b7527b310329e9c126944ec544efb9a5470151c9c32"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "b3dfa213472c29f3db4612571e2ae6519e6845e48249449f39c3a5af7547b325"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1430775dc57a17488b6f8daf609587c7f8c8283559fc8b5b38c3f1323b0dae87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "55650a35669978cfaef6ff9ee66626234ea662a853ec5e5dcb26018835287eb3"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1"

    ldflags = %W[
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
