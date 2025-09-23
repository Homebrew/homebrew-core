class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https://gnmic.openconfig.net"
  url "https://github.com/openconfig/gnmic/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "a684f627680eff51acec81f8eb3c4fa920c32b05afde0c040e9c51d1d2fe3067"
  license "Apache-2.0"
  head "https://github.com/openconfig/gnmic.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d935715db6f289a692489c03ad062bc856d5d1d3456607e79fc50d625269f2a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fcd24eccee10681afac6e6521019b46888d04ec6407f9f490afacd8d96fef3a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fcd24eccee10681afac6e6521019b46888d04ec6407f9f490afacd8d96fef3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5fcd24eccee10681afac6e6521019b46888d04ec6407f9f490afacd8d96fef3a"
    sha256 cellar: :any_skip_relocation, sonoma:        "2bbd01e38ff950c8741754ef25a8be572d8e6c1537db0f04ec85c6e0574d7d54"
    sha256 cellar: :any_skip_relocation, ventura:       "2bbd01e38ff950c8741754ef25a8be572d8e6c1537db0f04ec85c6e0574d7d54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b231254c7d76ec467980b2b47ac34a1cd2fe3e2e42379f66b276cf45039ec3f"
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
