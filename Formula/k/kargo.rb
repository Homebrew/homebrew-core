class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.10.4.tar.gz"
  sha256 "e65ffeb5dfac547d20b6f86b62463f53e2f915809f02a6fa4fee2f772df2eb39"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b78d57e1907fce818ea4ac3bb8a7ed52d5e3a69f887b32bffa5d75e7e40bd98b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7798685a88d28e172c80a2583040825b1a8775e6028b057f33ca657c0cd084f5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1dcca3a8d83cf2ef89ace7d8d5c220be896b556c2af7f81a3806c22b69b2c56a"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa16849897615a7ebdbd4c5d674b0fa3ef07d76c0901148a1c0ee7409f33182f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0de910914ab30b101640ad0b9263688a7b967ae8e31f3eaec040c80a81bd412"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa67d77677172fbba2630c313c4cb727c652017627414cc507ea227bf935171e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/akuity/kargo/pkg/x/version.version=#{version}
      -X github.com/akuity/kargo/pkg/x/version.buildDate=#{time.iso8601}
      -X github.com/akuity/kargo/pkg/x/version.gitCommit=#{tap.user}
      -X github.com/akuity/kargo/pkg/x/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli"

    generate_completions_from_executable(bin/"kargo", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kargo version")

    assert_match "kind: CLIConfig", shell_output("#{bin}/kargo config view")
  end
end
