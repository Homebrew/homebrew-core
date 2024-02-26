class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.3.44.tar.gz"
  sha256 "033cda097e23d25c8af0986194c861ad6e305adaa15ab128b7457e71d189ecab"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f272e03133bd99fef61202fc9d5ce267957461772ccbabf2a7cfd3f487a64ce"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a41fab4d48b0839b3f945dd205de9f890f0736f651c924c77f59475bfebe87c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4838879c68073748186ceec01b2d285fff93a7187d872b3c754d809274060364"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fa31d517938a5fa2c55726669de347df418af3421cab6073b1c751a3ddab045"
    sha256 cellar: :any_skip_relocation, ventura:        "ba060ee5d7108df47fab4639626a9b8b625dab0ed8ea04ebf0012b9e2e63baf6"
    sha256 cellar: :any_skip_relocation, monterey:       "8e15236c1f82808b3e6269b4eb66b676d97b8f1514c04b97f75511e44b91b9d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b947be73ba261fc6744eb2c586778ccdd7fee635c44aae370cb9fcedbcf8f5d2"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    cd "cli" do
      system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/neosync"
    end

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connect: connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
