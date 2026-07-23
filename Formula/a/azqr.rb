class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.3.2.1",
      revision: "24d26c1b2e1e9580160857ab598b28badf478b5e"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21dc695dfb79edc7eb8d5c6d9d79e2849f652911d7505a0fd4f0608a60a30364"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21dc695dfb79edc7eb8d5c6d9d79e2849f652911d7505a0fd4f0608a60a30364"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21dc695dfb79edc7eb8d5c6d9d79e2849f652911d7505a0fd4f0608a60a30364"
    sha256 cellar: :any_skip_relocation, sonoma:        "6193113d5eb6959894a50395fdcb32302738caee712431c8aadb6232e4c666a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d2046d35b167b12b58d88ae1a56dcedb677908dae9faa245fb36b9cc095739c4"
    sha256 cellar: :any,                 x86_64_linux:  "c4d217e87d48bd1064e23f4860339a6cf0b9fe9dded56eac4d35cae49f048807"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}
    ]
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
