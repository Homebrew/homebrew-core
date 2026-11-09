class Grype < Formula
  desc "Vulnerability scanner for container images and filesystems"
  homepage "https://github.com/anchore/grype"
  url "https://github.com/anchore/grype/archive/refs/tags/v0.121.3.tar.gz"
  sha256 "ced703b9f94606d33f346369ec3d2f84aaa420147232b633d8d847987f9c64bd"
  license "Apache-2.0"
  head "https://github.com/anchore/grype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b9dd81b224fa3092657e2f9db6e80acdba0855a439256e3ff5cafcb2daf9f4c4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd0b5b351bb1c815a9d02c6934d8768e9af45ba3bb7d501a54474b5f408da050"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "feda1a7ca138642e80cb8cc2d012a052c4685c25a3501072454c6fd3bfc8e5fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ac85a00d47d787405e7523d62f5a2605f6327ab1f53c4be61dc22ff9bfea3c8b"
    sha256 cellar: :any,                 x86_64_linux:      "93c0f8dfa0c1fda250bc3c78eddfc3285337207611c17c4bea1c295db8e1d8ef"
  end

  depends_on "go" => :build

  # `test do` block downloads the vulnerability database
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.gitCommit=#{tap.user} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/grype"

    generate_completions_from_executable(bin/"grype", "completion")
  end

  test do
    assert_match "database does not exist", shell_output("#{bin}/grype db status 2>&1", 1)
    assert_match "update to the latest db", shell_output("#{bin}/grype db check", 100)
    assert_match version.to_s, shell_output("#{bin}/grype version 2>&1")
  end
end
