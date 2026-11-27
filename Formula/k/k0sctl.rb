class K0sctl < Formula
  desc "Bootstrapping and management tool for k0s clusters"
  homepage "https://github.com/k0sproject/k0sctl"
  url "https://github.com/k0sproject/k0sctl/archive/refs/tags/v0.34.0.tar.gz"
  sha256 "d9347c8f408714aabe1311ac1464180a02239e700cf411522c97e172fe1002c0"
  license "Apache-2.0"
  head "https://github.com/k0sproject/k0sctl.git", branch: "main"

  bottle do
    manifest_sha256 "8a533148b87d379cb3e3f23c5ffac56f325dcba5fa854a08c1bd990a472b9961"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4b37335fb8fe64e16f0fcd4f731c4f8cf921811c0904e602341c93abbf316994"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4b37335fb8fe64e16f0fcd4f731c4f8cf921811c0904e602341c93abbf316994"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4b37335fb8fe64e16f0fcd4f731c4f8cf921811c0904e602341c93abbf316994"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0396c60ee9a2e4ae96eb41e020d605ca6b413e3ccd8453bf040cb223c7731cc6"
    sha256 cellar: :any,                 x86_64_linux:      "5c01d61d116fb7fc868524f7cd6071064f25832620f2e35180bea0a1587bba30"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    inreplace "version/version.go", "Version = versioninfo.Version", "Version = \"v#{version}\"" if build.stable?

    ldflags = %W[
      -X github.com/k0sproject/k0sctl/version.Environment=production
      -X github.com/carlmjohnson/versioninfo.Revision=#{tap.user}
      -X github.com/carlmjohnson/versioninfo.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k0sctl", "completion", "--shell")
  end

  test do
    assert_match "version: v#{version}", shell_output("#{bin}/k0sctl version")

    output = shell_output("#{bin}/k0sctl init")
    assert_match "apiVersion: k0sctl.k0sproject.io/v1beta1", output

    output = shell_output("#{bin}/k0sctl init --cluster-name brew-test")
    assert_match "name: brew-test", output
  end
end
