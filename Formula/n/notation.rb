class Notation < Formula
  desc "CLI tool to sign and verify OCI artifacts and container images"
  homepage "https://notaryproject.dev/"
  url "https://github.com/notaryproject/notation/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "f7239ca8155329b57f80e5fb01bf189441b3ade572ad9d6fc4582c1475b8e840"
  license "Apache-2.0"
  head "https://github.com/notaryproject/notation.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f725b7dedf7c9605ed2a6733b0a8dcce2738d3dd6b3422fcb8a1c349ca2fd495"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4bdb5bb2c42513ae6b08e6fc8da7b11a7e7caf9693d24375f296a9b5fa28386"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4bdb5bb2c42513ae6b08e6fc8da7b11a7e7caf9693d24375f296a9b5fa28386"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4bdb5bb2c42513ae6b08e6fc8da7b11a7e7caf9693d24375f296a9b5fa28386"
    sha256 cellar: :any_skip_relocation, sonoma:        "da080867497c76b99f1499f3394e0dff732029f3c946e46a3a24e670b7ca3e35"
    sha256 cellar: :any_skip_relocation, ventura:       "da080867497c76b99f1499f3394e0dff732029f3c946e46a3a24e670b7ca3e35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4e4276032d96d841d5c4906a097480d2aa27188d9b68be6d327a6aceddc14f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31bd008ba39c788f55adee11eed08cc7da11ef52f052818d000d6b22f3bc1c9a"
  end

  depends_on "go" => :build

  def install
    project = "github.com/notaryproject/notation"
    ldflags = %W[
      -s -w
      -X #{project}/internal/version.Version=v#{version}
      -X #{project}/internal/version.GitCommit=
      -X #{project}/internal/version.BuildMetadata=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/notation"

    generate_completions_from_executable(bin/"notation", "completion")
  end

  test do
    assert_match "v#{version}+Homebrew", shell_output("#{bin}/notation version")

    assert_match "Successfully added #{tap.user}.crt to named store #{tap.user} of type ca",
      shell_output("#{bin}/notation cert generate-test --default '#{tap.user}'").strip
  end
end
