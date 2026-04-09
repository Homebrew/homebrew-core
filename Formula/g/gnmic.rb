class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https://gnmic.openconfig.net"
  url "https://github.com/openconfig/gnmic/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "47caa59c65c03bbb33959998fadc677039c32e268f66664f18a98e8e31f71603"
  license "Apache-2.0"
  head "https://github.com/openconfig/gnmic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77d60f36777ffc35eda87eac7a4e08f5850c2d1615705539db9dedd3ee0711de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42be4b9d3bb943bacf490f7d6545cd585fd5b07b0d0c9550354974f32e3665f8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1601f22299945fd7d183d3128fe01c8740bdbb17b190993375c175c71540090"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfe60090931a5ca1322ce3947d4b67dc0c9dd9c6461378136445c692886e8f14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74a7d3f6c3582109701eb390f20b0c6bb263b50ab70605639c031a9c2d744b00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6658800fe3c4fff610a3e98c16026f0133273ed160c98a50f3fb140a7d7fb11"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
