class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://github.com/unikraft/kraftkit/archive/refs/tags/v0.12.6.tar.gz"
  sha256 "7c22a178a6a04bdd5ef6dadd4f04ded4a9ded75a19b48b24e57d8ea71fbb256e"
  license "BSD-3-Clause"
  head "https://github.com/unikraft/kraftkit.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c071c6ba4e3dcf1a84b14680c48482d014f834acb9e308e998564e1ab1e55b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "066b66c9ad0a4c754d00986096e5571b2261640c3b46e904b0dbc916ed55ba2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a62054124277ed3b9c5f6b9e89e09e1db512e9e4769f39066f467900a52addad"
    sha256 cellar: :any_skip_relocation, sonoma:        "da3c1760468576e2d599322d33a03262f77a8a845493123428699e6d27de98f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "273ddf39a81b1c0fef3dab45ab4391c9b6dbcd5445fdc9879be4b098083f5a3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c97abb166049ffd20efea77a41f18713df2d4822be48a6f4c8230938b3ba705"
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
