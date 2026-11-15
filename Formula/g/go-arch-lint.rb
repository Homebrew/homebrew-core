class GoArchLint < Formula
  desc "Architecture linter for Go projects"
  homepage "https://github.com/fe3dback/go-arch-lint"
  url "https://github.com/fe3dback/go-arch-lint/archive/refs/tags/v1.19.1.tar.gz"
  sha256 "b3829f82788f6f5b0b741a25936d9d1d539fc8de6b3342bd2bfa34b0eabe53c9"
  license "MIT"
  head "https://github.com/fe3dback/go-arch-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c2b10fe9c840447a62e693526fbb4a09e25ec501793b9a1ffacc3b1080891b5e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c2b10fe9c840447a62e693526fbb4a09e25ec501793b9a1ffacc3b1080891b5e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c2b10fe9c840447a62e693526fbb4a09e25ec501793b9a1ffacc3b1080891b5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8e159ab3bad30ca229312f4f599343d961c46a0f5370d010768112252d173abe"
    sha256 cellar: :any,                 x86_64_linux:      "81a64ce8c1bd2408bda01a50e78691c9e78e1d5972d58db77f99ace737671bcf"
  end

  depends_on "go"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X github.com/fe3dback/go-arch-lint/internal/app.Version=#{version}")

    generate_completions_from_executable(bin/"go-arch-lint", shell_parameter_format: :cobra)
  end

  test do
    version_output = JSON.parse(shell_output("#{bin}/go-arch-lint version --json"))
    assert_equal version.to_s, version_output.dig("Payload", "LinterVersion")

    system "go", "mod", "init", "example.com/brewtest"

    (testpath/"repository/repository.go").write <<~GO
      package repository

      func Value() int { return 1 }
    GO

    (testpath/"service/service.go").write <<~GO
      package service

      import "example.com/brewtest/repository"

      func Value() int { return repository.Value() }
    GO

    (testpath/".go-arch-lint.yml").write <<~YAML
      version: 3
      components:
        service: { in: service }
        repository: { in: repository }
      deps: {}
    YAML

    output = JSON.parse(shell_output("#{bin}/go-arch-lint check --json", 1)).fetch("Payload")
    assert_empty output.fetch("ExecutionWarnings")
    assert_equal 1, output.fetch("ArchWarningsDeps").length
    warning = output.fetch("ArchWarningsDeps").first
    assert_equal "service", warning.fetch("ComponentName")
    assert_equal "example.com/brewtest/repository", warning.fetch("ResolvedImportName")

    inreplace testpath/".go-arch-lint.yml", "deps: {}", <<~YAML.chomp
      deps:
        service:
          mayDependOn: [repository]
    YAML

    output = JSON.parse(shell_output("#{bin}/go-arch-lint check --json")).fetch("Payload")
    assert_empty output.fetch("ExecutionWarnings")
    assert_equal false, output.fetch("ArchHasWarnings")
  end
end
