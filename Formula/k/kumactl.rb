class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/2.8.2.tar.gz"
  sha256 "362ea4403d8c7d0926f24ebe839d6981c50c408300c3623521fe9741945d721f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b80a69e84055381af6ff9d5682efcb30350f383a05cdc8d0001fe616d9d96842"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2067a50e126b21944594c55802eb96bd4ccbe9f9f2c5bccd93f514c44ddf2f71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f18dce8c7d0c741f9d2c95cd8737f200f256eb74dfca6420561778985d54ecb7"
    sha256 cellar: :any_skip_relocation, sonoma:         "246dee1f8aa1287625e51cd71091715b70dd8d807a4b2978d4ffcb793d01e278"
    sha256 cellar: :any_skip_relocation, ventura:        "1c5bf920744a2e9dd2567ef6ccb121e2ae189cc772f7fd8b2a301c4772917691"
    sha256 cellar: :any_skip_relocation, monterey:       "224def4ba5476fe2b74cd7b3331165aa42b82cbf724922e9812b1767f42bc588"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c572af83f9e5a4b57eec4bdb82fbacc31df24465996a48c5e8567a635f196679"
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
    assert_match "Management tool for Kuma.", shell_output(bin/"kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
