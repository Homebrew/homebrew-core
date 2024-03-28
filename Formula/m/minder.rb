class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://minder-docs.stacklok.dev"
  url "https://github.com/stacklok/minder/archive/refs/tags/v0.0.38.tar.gz"
  sha256 "c5bb28bb4c3c71c81f40c2fc207114e67df14d6c31d15e2d73f78653c5bbc385"
  license "Apache-2.0"
  head "https://github.com/stacklok/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a011d387fc642029da8116e8df95434c0b06390d91a320ee3eacc6947a72dadc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c34978b89faac7a8c75991448db82c8b3f9337cfacea1444686f011acdd0fe4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "851d0966b348e3292e4ba4991da4fd2f85c3eb7f125b773a8f11a6cbf2299afa"
    sha256 cellar: :any_skip_relocation, sonoma:         "72b6edd222061a716edc7481ed164bf5adeeb57769096802e4c14612b1592539"
    sha256 cellar: :any_skip_relocation, ventura:        "7095ff76ea1a15f7950f284c2da066fae6f58e322a1271da9de72cb98afac8e2"
    sha256 cellar: :any_skip_relocation, monterey:       "d7aff3c2cabe4386f2a41db2e66739b81a819b3c3b7d9aa3bb7f87d044d5bb86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8db9a6d2f51a4ac1fa64508e82c414ce476e116ff464a994514af3b0363f69d"
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
