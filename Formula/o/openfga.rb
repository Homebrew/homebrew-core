class Openfga < Formula
  desc "High performance and flexible authorization/permission engine"
  homepage "https://openfga.dev/"
  url "https://github.com/openfga/openfga/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "1b7e22145ade674dd2cc93a56f9d2e9ba055b6a939566a57190c3508f7087ff2"
  license "Apache-2.0"
  head "https://github.com/openfga/openfga.git", branch: "main"

  bottle do
    manifest_sha256 "345ca469c735bc91d69072e44baadccbb14a80a19768bdd84eed89c99a8a40af"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e82a83e928d3f461f10f911ce08009e48b2a90945690380161e6342954a4e24c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "7e5bec4aabc646382a48118aedba10f73aa35c04ba2788e933a4f9d0b53fe8ce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a9cb1d81cfcbaca032d3a7f4eda6b5bdd5316de9979893e86d25247fa5f138a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3ca0d8dc92187323c0789ad5850958393214cd99e0834c9b08bac058e04c2ccd"
    sha256 cellar: :any,                 x86_64_linux:      "9c5e20388e11d0d225f319f95321e27d3e5fad63545980d8e691e9a5a92b5dd5"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/openfga/openfga/internal/build.Version=#{version}
      -X github.com/openfga/openfga/internal/build.Commit=#{tap.user}
      -X github.com/openfga/openfga/internal/build.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/openfga"

    generate_completions_from_executable(bin/"openfga", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/openfga version 2>&1")

    port = free_port
    with_test_process(bin/"openfga", "run", "--playground-enabled", "--playground-port", port.to_s) do
      sleep 3
      output = shell_output("curl -s http://localhost:#{port}/playground")
      assert_match "title=\"Embedded Playground\"", output
    end
  end
end
