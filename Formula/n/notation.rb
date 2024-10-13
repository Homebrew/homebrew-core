class Notation < Formula
  desc "CLI tool to sign and verify OCI artifacts and container images"
  homepage "https://notaryproject.dev/"
  url "https://github.com/notaryproject/notation/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "e792c8991e2fa03bbe65623f4232345c369cd91107014c36ec67f5666b8e0041"
  license "Apache-2.0"
  head "https://github.com/notaryproject/notation.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "8f154bacbf4da75dab08520d7a574bb1dbf271960290d83200b4d44260c2fbd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8257d351a65fd2ad5b0d66c99b4bf332a067c49cb0d581b1a0b81b96c90c3af2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8257d351a65fd2ad5b0d66c99b4bf332a067c49cb0d581b1a0b81b96c90c3af2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8257d351a65fd2ad5b0d66c99b4bf332a067c49cb0d581b1a0b81b96c90c3af2"
    sha256 cellar: :any_skip_relocation, sonoma:         "94198be627dfa4aa0bc197a41901491b9ee5ac9de28c2f1ea17fdc5a48805469"
    sha256 cellar: :any_skip_relocation, ventura:        "94198be627dfa4aa0bc197a41901491b9ee5ac9de28c2f1ea17fdc5a48805469"
    sha256 cellar: :any_skip_relocation, monterey:       "94198be627dfa4aa0bc197a41901491b9ee5ac9de28c2f1ea17fdc5a48805469"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24561723cc8e33f7f5b97d051e1187683ad46f312734e98f36a3eb479a126706"
  end

  depends_on "go" => :build

  def install
    project = "github.com/notaryproject/notation"
    ldflags = %W[
      -s -w
      -X #{project}/internal/version.Version=v#{version}
      -X #{project}/internal/version.GitCommit=
      -X #{project}/internal/version.BuildMetadata=Homebrew
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
