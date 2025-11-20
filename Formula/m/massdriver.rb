class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.13.2.tar.gz"
  sha256 "3b80182d1704afb67b40ff95c84298d8b14bd8bd4ad5dfdb2a906b9c2e01916e"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "96188d015aded7d05d719223bbd97ac35fa6e2180f1fb6e3b49c47e339752f30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96188d015aded7d05d719223bbd97ac35fa6e2180f1fb6e3b49c47e339752f30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "96188d015aded7d05d719223bbd97ac35fa6e2180f1fb6e3b49c47e339752f30"
    sha256 cellar: :any_skip_relocation, sonoma:        "54a4af48fd0955ce1485833bfc1e1093e54a1ae8a579b7b13a7d138980baec7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5758485d91dfd98bee8aafe1bbcdc2ede7b96771eb05b47e5aa6d51dd034111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d2353441e27e793b5d915d7d2b57389cb521c84c2ff7c5a48c78f79cad71ac4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")

    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mass version")

    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output
  end
end
