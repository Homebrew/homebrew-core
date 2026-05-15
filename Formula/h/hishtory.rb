class Hishtory < Formula
  desc "Your shell history: synced, queryable, and in context"
  homepage "https://hishtory.dev"
  url "https://github.com/ddworken/hishtory/archive/refs/tags/v0.335.tar.gz"
  sha256 "f312acc99195ca035db7b6612408169ce3a14c170f85dba238f9a29ca7825a3d"
  license "MIT"
  head "https://github.com/ddworken/hishtory.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "99dec873524b0cd5ac384478afd990b0ed9ed606c9bc6c94e8c3e7c0622747bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99dec873524b0cd5ac384478afd990b0ed9ed606c9bc6c94e8c3e7c0622747bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99dec873524b0cd5ac384478afd990b0ed9ed606c9bc6c94e8c3e7c0622747bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "efc3d5ab95c59a45cc6ca7c5caf7e367f419c3dfc25755875882a1fe33f91558"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dffdda94fe7ba567cdb165781632e0e3cfc24553b638cb6b45eee1de5684e493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13d274f6feb130825393ffa5e24e6fe5e8bf1aca290214fda7c1f17fbe6c4270"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ddworken/hishtory/client/lib.Version=#{version}
      -X github.com/ddworken/hishtory/client/lib.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"hishtory", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hishtory --version")

    output = shell_output("#{bin}/hishtory init --offline")
    assert_match "Setting secret hishtory key", output
    assert_match "Enabled: true", shell_output("#{bin}/hishtory status")
  end
end
