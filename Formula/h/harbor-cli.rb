class HarborCli < Formula
  desc "CLI for Harbor container registry"
  homepage "https://github.com/goharbor/harbor-cli"
  url "https://github.com/goharbor/harbor-cli/archive/refs/tags/v0.0.14.tar.gz"
  sha256 "a0518de7b09f0aac262a556d51a149841846dc85a5a4a1eebe79b6da68b6468b"
  license "Apache-2.0"
  head "https://github.com/goharbor/harbor-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7dba396bcb743afdb4369377188da49c0c7c9401ca02cda017a67f10c7366c0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7dba396bcb743afdb4369377188da49c0c7c9401ca02cda017a67f10c7366c0c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7dba396bcb743afdb4369377188da49c0c7c9401ca02cda017a67f10c7366c0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "21873226774fb128fe5b9762315e54f7a22aaccd781e9a658546e88a8d648b91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d263e0f8b5f28a38d06f5fbca4118661984e7b78b18c71b7a4a8a054f6deccdd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e78633ed481ca1e21566ea4036a3cdc5c8cbc7276da376d5c37efe96f9b4f1f0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.Version=#{version}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.GoVersion=#{Formula["go"].version}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.GitCommit=#{tap.user}
      -X github.com/goharbor/harbor-cli/cmd/harbor/internal/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"harbor"), "./cmd/harbor"

    generate_completions_from_executable(bin/"harbor", "completion", shells: [:bash, :zsh, :fish, :pwsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/harbor version")

    output = shell_output("#{bin}/harbor repo list 2>&1", 1)
    assert_match "Error: failed to get project name", output
  end
end
