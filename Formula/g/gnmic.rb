class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https://gnmic.openconfig.net"
  url "https://github.com/openconfig/gnmic/archive/refs/tags/v0.42.0.tar.gz"
  sha256 "6eb7ea65874e748b47bc01dd002d67dd54ee3d06093c050e1dbc7188d97fb560"
  license "Apache-2.0"
  head "https://github.com/openconfig/gnmic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1354f289e26ccdf5d5a1cfd104c671f4d48d08e4a482b8062b0027bde80d6894"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1354f289e26ccdf5d5a1cfd104c671f4d48d08e4a482b8062b0027bde80d6894"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1354f289e26ccdf5d5a1cfd104c671f4d48d08e4a482b8062b0027bde80d6894"
    sha256 cellar: :any_skip_relocation, sonoma:        "a023b6eb3e04cd4ace41153c47590d97c1e725f14968c982cc0d831ec243cc6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "446523e8a237f393d9a309a9477eb601a3435187fc6d3bec9ac5887a71d559a1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/openconfig/gnmic/pkg/app.version=#{version}
      -X github.com/openconfig/gnmic/pkg/app.commit=#{tap.user}
      -X github.com/openconfig/gnmic/pkg/app.date=#{time.iso8601}
      -X github.com/openconfig/gnmic/pkg/app.gitURL=https://github.com/openconfig/gnmic
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
