class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://minder-docs.stacklok.dev"
  url "https://github.com/stacklok/minder/archive/refs/tags/v0.0.52.tar.gz"
  sha256 "daeb3b9cae8c0bcecb54d34a51f5ddffcd58cb3a095aea0227ce7832d9b59842"
  license "Apache-2.0"
  head "https://github.com/stacklok/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0c52cf36872e8f8e60755a34927a8b6cfa25351a658456afe17badbe1e5db4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a691832d1e2c3166a1c4e209d1c48bca9988ab700afcc67da979aae505fc6729"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d57c87a936c7d9b6b508795f2bb60e3d5eabf346d5af7fd34d1f62116d01ea0"
    sha256 cellar: :any_skip_relocation, sonoma:         "248a592b91d909f93d95f791cc31103a002e6988faa23cea9dddcc7d10e74f89"
    sha256 cellar: :any_skip_relocation, ventura:        "c7d57da2ab59a5429eee487c8e800e85b0e20482bc829d6c33f06176f90a9d9e"
    sha256 cellar: :any_skip_relocation, monterey:       "f76fcd68e18493a8691ce6b00ee51f95ddcd8810ab45b0489f04d635870158f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e067273a63f3e92c77d2267a3af0423840f62e8abdde819234ff2472e23d363"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/stacklok/minder/internal/constants.CLIVersion=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"minder", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minder version")

    output = shell_output("#{bin}/minder artifact list -p github 2>&1", 16)
    assert_match "No config file present, using default values", output
  end
end
