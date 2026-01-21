class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://github.com/unikraft/kraftkit/archive/refs/tags/v0.12.5.tar.gz"
  sha256 "72ae21a2b20e4d3d85e22977c5025a6c7349acc96ad596fe6b66a3d5d94b547c"
  license "BSD-3-Clause"
  head "https://github.com/unikraft/kraftkit.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4460e2412f7ea04f7c54620fc216d2003e52ec18105c7d6bc5f31fde127f308f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "288353d2c31c6790592b148ddf832e5938cc493357573f728e3dc295731afa2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b2cc8d32fd996e0f334f914bb9251f57573d8ec4255218740f736ce089d4c614"
    sha256 cellar: :any_skip_relocation, sonoma:        "780657ed9827075fb1c6e8ce48505e82c5ff042d348d864579f80b80eb585102"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b38b10881e0648a3a369a5f5c15d46ee5d8016ab695aa319fa44c4d13a6e8d00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cce0e5b120ca6b93221ee7f940f72fc080ff4c5034bb5268b56f08aeecf6368a"
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
