class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/2.6.1.tar.gz"
  sha256 "9d09c09b98f1ddd9c611794e8782bcc53fa61829525a0a2b543a7b952fee81fd"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b621fbd922416effcb946e0d9b5dfd6908a9a90f3026e5ca55ea2f1f0b538f6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a02b72d76f1156e1bff11c1071cd6959bb1cc5dae53d72f9d791041972fe9926"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b581b3d59b498bcd930cc593965986bae75203ee342ef3992b753c6f5095fa85"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce0d212b22a563b2dc112f679f691c2f2ba247a5ddcfa3a7bcd3c0295868f4a3"
    sha256 cellar: :any_skip_relocation, ventura:        "2c9d691fdf8c317725cd208fd90719959b29557ef9f592cf9630c871082b4cc0"
    sha256 cellar: :any_skip_relocation, monterey:       "15f7dba048b8ceec4d8ac7beff0f4334516827c808b7a1787e0d0ba24702b896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d3c36c9c63db2b64479b307a8b15bf1a7edc8200fbb9a4441e12a3e51600759"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", "completion")
  end

  test do
    assert_match "Management tool for Kuma.", shell_output("#{bin}/kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
