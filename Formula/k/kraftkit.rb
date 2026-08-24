class Kraftkit < Formula
  desc "Build and use highly customized and ultra-lightweight unikernel VMs"
  homepage "https://unikraft.org/docs/cli"
  url "https://github.com/unikraft/kraftkit/archive/refs/tags/v0.12.15.tar.gz"
  sha256 "285028e9216723ba8b4ec1bf8ce2b4d121ba76f186519b6ebc2fa4b99e53c828"
  license "BSD-3-Clause"
  head "https://github.com/unikraft/kraftkit.git", branch: "staging"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a1ff6697028d85f8fcf4e22517155d523209135e395abbc7e654f4a1bf0cbf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eee06a268e1cd6d16e8530be4651f765a30b459218414824da25b17ada16e729"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0523ba9d72bb17c7e2783a861142d8c499c017f122c7971f921f369dbf73b9ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7b20fdffb21c9b2171a74c37658f002a4550ed2f11eec2016773b3efcfaaac8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5e8ac3e5594eb862d90ffb7db27cbe4a8deb294692292b1f7326168d04f0cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "92f2d1640760d6422693fedae1cdcc16a40793625d41e310cc7b65d76f324f73"
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
