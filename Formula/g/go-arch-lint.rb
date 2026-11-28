class GoArchLint < Formula
  desc "Architecture linter for Go projects"
  homepage "https://github.com/fe3dback/go-arch-lint"
  url "https://github.com/fe3dback/go-arch-lint/archive/refs/tags/v1.19.3.tar.gz"
  sha256 "0193552dfe0c3c036eb46a0b50019199d9f41b55f5c26bcd3880bf435b6fb886"
  license "MIT"
  head "https://github.com/fe3dback/go-arch-lint.git", branch: "master"

  bottle do
    manifest_sha256 "702809338407b6d2e0b238822cb7f72bea3defc1eec9517c0db688a3deeffc94"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8657c3f1c8ee8990f1c45493010934e3f90b670ae4028776d5e54b171e34a8f6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8657c3f1c8ee8990f1c45493010934e3f90b670ae4028776d5e54b171e34a8f6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8657c3f1c8ee8990f1c45493010934e3f90b670ae4028776d5e54b171e34a8f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bd8199211f0324527343bf0b24295974fe3fa5026a9e0dbc8b32b67a279866dd"
    sha256 cellar: :any,                 x86_64_linux:      "1e3f2664fda726f4704399dad2ef6ebe0b1ad9003d169ed4cd8839d4baccc3b7"
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
