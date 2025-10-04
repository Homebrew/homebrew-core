class Atlas < Formula
  desc "Database toolkit"
  homepage "https://atlasgo.io/"
  # Upstream may not mark patch releases as latest on GitHub; it is fine to ship them.
  # See https://github.com/ariga/atlas/issues/1090#issuecomment-1225258408
  url "https://github.com/ariga/atlas/archive/refs/tags/v0.37.0.tar.gz"
  sha256 "205bcaa42391713c4fb452f49be082dcbba504117ae5cf0a1b06e6d908433fe2"
  license "Apache-2.0"
  head "https://github.com/ariga/atlas.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dc860b56111aaf5dd55ec2c44d9b1edc2d703c4ce3058ddd094640afd675f6d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e29a668a2557e1a85a9ea932fb3182b8fb5e779656459af0f1e5aac0497dec8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f3d385530cce2c278d58bf411ed2bc94db9510e4b4e8d084c8d25181fb8441b"
    sha256 cellar: :any_skip_relocation, sonoma:        "e08285e3dc89dccd22ed1febfbe254fbb48e130c7979ffa2e0eb54325d2ffdf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0db24cfea1503931763b51a8ddabe5da42473587b59135d02548bdb60d5f625"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bae98785248e6d12ab805dd5f821f2ef270185441c8b2d32bcdc50a230147556"
  end

  depends_on "go" => :build

  conflicts_with "mongodb-atlas-cli", "nim", because: "both install `atlas` executable"

  def install
    ldflags = %W[
      -s -w
      -X ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v#{version}
    ]
    cd "./cmd/atlas" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"atlas", "completion")
  end

  test do
    assert_match "Error: mysql: query system variables:",
      shell_output("#{bin}/atlas schema inspect -u \"mysql://user:pass@localhost:3306/dbname\" 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/atlas version")
  end
end
