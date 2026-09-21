class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https://gnmic.openconfig.net"
  url "https://github.com/openconfig/gnmic/archive/refs/tags/v0.49.0.tar.gz"
  sha256 "59c238fb3c5e8b7280e6d743cf2f569fdf0abe2f2b8fe147871ceaf22f59a0ba"
  license "Apache-2.0"
  head "https://github.com/openconfig/gnmic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "001b4767bc321b433c508b6dd29b8bbcefbc13d01501bf6123b347a5e9960ef2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "93c2fb4e7aa51e2547db4f89b7954f74dcb9f948a0126ddc5d5ebb8ce9a5cca5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d7ee01e78cbce6ca9b510e33c944cb42f563553a34b4b39b66cec9671eec3ea5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "80f60cb2c1ad0649b9b222a7407bced83399d3c4e5b8d373ca75e5a23a9434ba"
    sha256 cellar: :any,                 x86_64_linux:      "9555f73a3b3d767dfc03f425d7e726b01bf6b4a755008341a013c017fa4daae0"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/openconfig/gnmic/pkg/version.Version=#{version}
      -X github.com/openconfig/gnmic/pkg/version.Commit=#{tap.user}
      -X github.com/openconfig/gnmic/pkg/version.Date=#{time.iso8601}
      -X github.com/openconfig/gnmic/pkg/version.GitURL=https://github.com/openconfig/gnmic
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"gnmic", "completion")
  end

  test do
    connection_output = shell_output("#{bin}/gnmic -u gnmi -p dummy --skip-verify \
                                     --timeout 1s -a 127.0.0.1:0 capabilities 2>&1", 1)
    assert_match "target \"127.0.0.1:0\", capabilities request failed", connection_output

    assert_match version.to_s, shell_output("#{bin}/gnmic version")
  end
end
