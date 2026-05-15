class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://github.com/unikraft/kraftkit/archive/refs/tags/v0.12.11.tar.gz"
  sha256 "25eff0cbe79527a3ccb792d238a7df8a76c4d505db6015f16b27be1d8be40e51"
  license "BSD-3-Clause"
  head "https://github.com/unikraft/kraftkit.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fa76637f084c45dce2a0c02389e8c9beb333587664f5e779d8cc16cee7c2f1c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "65f4f4f24b07ee417c8b96ab0b8e3712cbe78537e595ad898ea850c2d60868d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c53916d5576bca5553a24fcc56a6b2d5a2249374bede73fd1485911b2ddd60f"
    sha256 cellar: :any_skip_relocation, sonoma:        "46bf368d7a9ff9381ba4b329377594334bda8ea90ef22313c4dc4f58ad33183e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e472f1bbbf79857f32c7893c4b815b6ee953d5b498075dcd5198c6f211f68bfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25ae0c93927fdd73e40d0921b5b25b418d215b04fdb08a696c04a16de8d0fa99"
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
