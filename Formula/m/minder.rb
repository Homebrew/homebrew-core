class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://minder-docs.stacklok.dev"
  url "https://github.com/stacklok/minder/archive/refs/tags/v0.0.36.tar.gz"
  sha256 "4b2ad28301b1c351c44bbfe411b61368b1ecae96df74d0b963e8f5faea88a1e7"
  license "Apache-2.0"
  head "https://github.com/stacklok/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "29c45efc4feea84e36afa101c5140517782e1ded5a23ce9d7e1640908d0e7fc5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cbd381772d62ede78200d9892bc325ac468bdedec3d433d37e06674a49b6abf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4441c42da5e4d81b400b28ce504e4bd0af69f383b5ddfdeb87b2e68438e2826c"
    sha256 cellar: :any_skip_relocation, sonoma:         "92d2475a92b6daab5d796e04b8aeddfa1f21b0f5631b0d005cb6504c2c002cf0"
    sha256 cellar: :any_skip_relocation, ventura:        "77c23aa3f36d1f59db8521508d42da5d518c2b6ecc1fae0861f7ed458d2a9b96"
    sha256 cellar: :any_skip_relocation, monterey:       "9bcfeed16065d61bd15f9773e9dbe83192dda12b20d0b6416f8b1d3ae7e5bc94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4ccb22a4d5a80a77a05eb29651ba94f9889ceb56acf74570ca349a5b8e09312"
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
