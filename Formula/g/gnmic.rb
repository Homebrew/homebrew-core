class Gnmic < Formula
  desc "GNMI CLI client and collector"
  homepage "https://gnmic.openconfig.net"
  url "https://github.com/openconfig/gnmic/archive/refs/tags/v0.41.0.tar.gz"
  sha256 "79db2cdd7dfe55edefdb7dcdd1c4403fdc5cb9378385f23456d16a740cc6ec24"
  license "Apache-2.0"
  head "https://github.com/openconfig/gnmic.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f1d0cbcd8a25bb3cddc1880de6cb9851c5f5ed23e08670f39ea478f49e5077d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f1d0cbcd8a25bb3cddc1880de6cb9851c5f5ed23e08670f39ea478f49e5077d0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f1d0cbcd8a25bb3cddc1880de6cb9851c5f5ed23e08670f39ea478f49e5077d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "28a7a8bbe69b73b932b7fe953b2a7eb9f92292d353e0fb0849bfa3974a7646e0"
    sha256 cellar: :any_skip_relocation, ventura:       "28a7a8bbe69b73b932b7fe953b2a7eb9f92292d353e0fb0849bfa3974a7646e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "095e1928f48bbb9fa6b0ed71308a4937f504de09242908080ce62d8f0c5f3de2"
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
    assert_match "target \"127.0.0.1:0\", capabilities request failed", connection_output

    assert_match version.to_s, shell_output("#{bin}/gnmic version")
  end
end
