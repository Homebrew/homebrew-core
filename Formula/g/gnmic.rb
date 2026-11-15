class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https://gnmic.openconfig.net"
  url "https://github.com/openconfig/gnmic/archive/refs/tags/v0.49.1.tar.gz"
  sha256 "4f3ad40acb2fc4643eecbd4f0feb3b979f9b1139ff492aeb90dc02c309012c5c"
  license "Apache-2.0"
  head "https://github.com/openconfig/gnmic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fe920e2a67076bad624a721f091509f65fe0ab1696732376adf24c313f5ed9cf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2073486f46ba8abf7e982d5046106ed0f0b5497373aaa65277d67294aa511782"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c74dc1e8e239ddfa83c7f7afc4b16155cdae49ea1a5f2090f102a5963185ff05"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e7b1be0e25c848345d113f330ef0050106ebd52f782dc9bf974a295502d97ce4"
    sha256 cellar: :any,                 x86_64_linux:      "901bb60b010c26aad3e7bc34992a85b34fc28db336efb1b55b48c5fa705e3737"
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
