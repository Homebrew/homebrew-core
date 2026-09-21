class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.4.1.3",
      revision: "234620309dd5b91797a80084af251e037bf3a3aa"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aec5128f760b9b94945a8f3304e637ef50cf59fcd9bb9bd832017d82ce6cf109"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aec5128f760b9b94945a8f3304e637ef50cf59fcd9bb9bd832017d82ce6cf109"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aec5128f760b9b94945a8f3304e637ef50cf59fcd9bb9bd832017d82ce6cf109"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "79863734bf264f3aec236cef373bb4cdee6655c50fa16f71807d259276766f03"
    sha256 cellar: :any,                 x86_64_linux:      "00891636ee2739ee95270d0ebbaf87a851a6c3b43e58fde1c48d915b6d7d62db"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end
