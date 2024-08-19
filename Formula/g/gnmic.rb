class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https://gnmic.openconfig.net"
  url "https://github.com/openconfig/gnmic/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "73085df18ce861d87abb6471823a464e4f7709a661a6a288155a653f98fee067"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "297b862e0cff23071352785cdc2a137062c93b7858414f20c3699170b5960073"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "018c10287f6fe99cf2bc5526c1b88f20e449a8e1821a5d3ff024bd6e2fadc7d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ec031ca0054a45bbb42261873d873f5ac759f5597dbad6a489f3199372ed480"
    sha256 cellar: :any_skip_relocation, sonoma:         "440e82b6ac4bd9f387d43417cfe89c1e53a39415a31e6c2af8f57dc615e4afab"
    sha256 cellar: :any_skip_relocation, ventura:        "bccbbd8dd775bfc2fe0d6a0af25d645e1036665d385d971c18aad36b265503b5"
    sha256 cellar: :any_skip_relocation, monterey:       "7ef0efc5b24bf7ea822c74222ebf6040fd438a076d9372284a910adf2e5552e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ce30a8710fad949bc2deb1c13ce4048c0e5e684cd6ca626b94c52f9703c6137"
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
    connection_output = shell_output(bin/"gnmic -u gnmi -p dummy --skip-verify --timeout 1s -a 127.0.0.1:0 " \
                                         "capabilities 2>&1", 1)
    assert_match "target \"127.0.0.1:0\", capabilities request failed: failed to create a gRPC client for " \
                 "target \"127.0.0.1:0\" : 127.0.0.1:0: context deadline exceeded", connection_output

    assert_match version.to_s, shell_output("#{bin}/gnmic version")
  end
end
