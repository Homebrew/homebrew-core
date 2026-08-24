class Kargo < Formula
  desc "Multi-Stage GitOps Continuous Promotion"
  homepage "https://kargo.io/"
  url "https://github.com/akuity/kargo/archive/refs/tags/v1.11.2.tar.gz"
  sha256 "9cdc85accb9e5b9f780b2e526545093fd2f5983acba3577b7287e26c229f7e5a"
  license "Apache-2.0"
  head "https://github.com/akuity/kargo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3ad81c16d8a665287f85db8a6b041cc33e5b66bf7cdc1fd2202b9fca6bcd44ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b53310ff510ab8204c09bdf6221159ff7684115b860a69f4dffa355c89df11d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05865b4aac0a4d9f540c295e03e57522daaa635c0a246ca68c761cfed6eaf8d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a0a4e55745310cbba61cc85c1587836b3cad8960959b03d03572939590c1412"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec796cfb663cf470d696f7872f9ea627df6e90e06c95926c3eb476c8e0ded065"
    sha256 cellar: :any,                 x86_64_linux:  "4ef238de28e9df303a676db22164e87b0d30ccf0b6b0ee5bd14eeaf5cf54223c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
