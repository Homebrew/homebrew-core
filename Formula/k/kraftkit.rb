class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://github.com/unikraft/kraftkit/archive/refs/tags/v0.12.14.tar.gz"
  sha256 "63d1aec55ae4e6826a4088ed3852b94b55d232bab1fefe45e20874d3318257d6"
  license "BSD-3-Clause"
  head "https://github.com/unikraft/kraftkit.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c461e857eb3705044e2b89fc5c27d22a32d7920b093b05bebf99a029e89c15c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c34f2438a31fa7a7dc6ca968b4854b9adf2b7aa70835be80f3242fc541a889b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c1d5bc5a92de523bf0d654206675166153ccd2a86857f57554069fa343ec1a2"
    sha256 cellar: :any_skip_relocation, sonoma:        "400f3c326179f17d08f6ff7ce7b7453cd2622bfcd77c62555f9266c3dd11f490"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4e89ed89778dba0fed560684e680409e847950cbf6ebaf0bc35ba121eb81ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9eed03622c66770445943a9e57c044c7f35dda81f49a7c3480b128109bb8b4b"
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
