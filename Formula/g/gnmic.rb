class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https://gnmic.openconfig.net"
  url "https://github.com/openconfig/gnmic/archive/refs/tags/v0.50.0.tar.gz"
  sha256 "132f2d80cd298d90fe906876d7a71dff3b5ffb3a8f8a3f56dd6564cb99e72c3a"
  license "Apache-2.0"
  head "https://github.com/openconfig/gnmic.git", branch: "main"

  bottle do
    manifest_sha256 "a05500ac99f520a41af1d266404e8055414d5199876ae85e7dc0aaecefc0c240"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "62df817cacd70117f061eea13871c073f476cbf991e24c288603766ea0db0c45"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "437a5109a106cc9e025e92f91b3d26b72665eb531448802265383efa3fc08782"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2ed69fe6e77fadfd2f17b73e246fdf764fcb45f85fc32bd271c32b93ccc0e844"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "53a73aee3f876bf0baeb329272477900e251b353ada1a47373a85b1d7357835d"
    sha256 cellar: :any,                 x86_64_linux:      "d148ca2e7c9e8034bd4c9156310ea05c28db7643e5ba7e9bbeee79559e37bb47"
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
