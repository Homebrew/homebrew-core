class Minder < Formula
  desc "CLI for interacting with Stacklok's Minder platform"
  homepage "https://minder-docs.stacklok.dev"
  url "https://github.com/stacklok/minder/archive/refs/tags/v0.0.34.tar.gz"
  sha256 "8f68966414428c99a7d6234d5602ab78cc1ac9094722b8a2485d910faf5adeec"
  license "Apache-2.0"
  head "https://github.com/stacklok/minder.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8a239ecdd8eec85df4b2c4b284b46902e576cd286cefc746ab1bde79ab338da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "febb5224c164d376c0a1dd0e4a086c4166db0d314700d0beca18a95281962b8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29c6ff0ffe3bac4e4254b18e25037edd394b1558cd205318bcee3c7bf0a32484"
    sha256 cellar: :any_skip_relocation, sonoma:         "88c54e1e0cdcc51a3e269f06ab81455e8623f4a4f7cfc4d4861fd34163460868"
    sha256 cellar: :any_skip_relocation, ventura:        "89134662f774fa470c06e41fef25d392b2fea41c4b5cd0620f0706e53d418a77"
    sha256 cellar: :any_skip_relocation, monterey:       "20af6f4149c05d2061ab0e7ffb9e1b3e22dd8525b277ff8804b97e4efab7ef00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffa2a70c4a53c2eb7b38d5b7adbd5c5ac51abd0d520f3124d803408960218a33"
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
