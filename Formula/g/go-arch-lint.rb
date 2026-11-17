class GoArchLint < Formula
  desc "Architecture linter for Go projects"
  homepage "https://github.com/fe3dback/go-arch-lint"
  url "https://github.com/fe3dback/go-arch-lint/archive/refs/tags/v1.19.2.tar.gz"
  sha256 "6bdf785c3a43a6020abf4ee7d1916980fed80100f4a9e0292d0e0cda08099559"
  license "MIT"
  head "https://github.com/fe3dback/go-arch-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "990e950c242a0d7de8bdfa034252c7e8dddd4d3c35e9f61a23d032f216bc5f6a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "990e950c242a0d7de8bdfa034252c7e8dddd4d3c35e9f61a23d032f216bc5f6a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "990e950c242a0d7de8bdfa034252c7e8dddd4d3c35e9f61a23d032f216bc5f6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8fe377bc0f3285b9c9a8e28b63774b6d2e39cb5dafc462b3ea95ef5269f6702d"
    sha256 cellar: :any,                 x86_64_linux:      "70f141e227e229dc6e0ea607e620343432bb28f826b853b22f706bf827ea3393"
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
