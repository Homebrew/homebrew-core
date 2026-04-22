class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://github.com/unikraft/kraftkit/archive/refs/tags/v0.12.10.tar.gz"
  sha256 "2c5e7af4e219bc8f4b99478c7186ca28a55a842777ce1cc489c635eab6e7570c"
  license "BSD-3-Clause"
  head "https://github.com/unikraft/kraftkit.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ed5354783bc7b17384f761979cf518bb50046d909b7349115e9ee7d74bc01d31"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0e329d60d66c3d97e4b8c8203ab6834903ad83be0c151057fcaa2687d97439a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b2f273805b250f3136bf3bfb9dc07686dc391de9ac5af934a2ca7b3d0792e3d"
    sha256 cellar: :any_skip_relocation, sonoma:        "03727123b6e75ee65ddceaa06bb0634db0758fbdbcbfbd4751586de4a1894f16"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "50c31370a394f2f577505cd2f420872f945cac8d3f44eab5d87f308a5c0dfa47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40b12f1556b02f15fe19fd0da506413127985c4a2307a62e416a28e6a209fafe"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "gpgme"

  on_linux do
    depends_on "btrfs-progs"
  end

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
    expected = if OS.mac?
      "could not determine hypervisor and system mode"
    else
      "finding unikraft.org/helloworld:latest"
    end
    assert_match expected, shell_output("#{bin}/kraft run unikraft.org/helloworld:latest 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/kraft version")
  end
end
