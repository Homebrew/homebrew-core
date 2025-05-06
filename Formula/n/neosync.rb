class Neosync < Formula
  desc "CLI for interfacing with Neosync"
  homepage "https://www.neosync.dev/"
  url "https://github.com/nucleuscloud/neosync/archive/refs/tags/v0.5.37.tar.gz"
  sha256 "38b9588fdb55c14f3569da2e2be6c3ff128132871f175c43cd211b5a3f59fa63"
  license "MIT"
  head "https://github.com/nucleuscloud/neosync.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed5357c5020d4c0555c2926f97f155179d0789b93b4f530ab68f5c98b7333fbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ed5357c5020d4c0555c2926f97f155179d0789b93b4f530ab68f5c98b7333fbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed5357c5020d4c0555c2926f97f155179d0789b93b4f530ab68f5c98b7333fbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "addc1107c5233a7aa54177371d7eb53e42be2fa5e50157f35d16705c2f870bf8"
    sha256 cellar: :any_skip_relocation, ventura:       "addc1107c5233a7aa54177371d7eb53e42be2fa5e50157f35d16705c2f870bf8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "28aa003dd6ee0822bd4c049009165ada9a452d75c3e97ee96f5941f0b7cb6841"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitVersion=#{version}
      -X github.com/nucleuscloud/neosync/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/nucleuscloud/neosync/cli/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cli/cmd/neosync"

    generate_completions_from_executable(bin/"neosync", "completion")
  end

  test do
    output = shell_output("#{bin}/neosync connections list 2>&1", 1)
    assert_match "connection refused", output

    assert_match version.to_s, shell_output("#{bin}/neosync --version")
  end
end
