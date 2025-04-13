class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/2.10.1.tar.gz"
  sha256 "03f49ee94353fd80c997929be338ebe0abeaad60286710fffa9d996e03ef1484"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "548d25075d89dd21a554620901d30b7b55ea5753469a149df0df672283b114b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16645e8ceaba12d28c82ecc7d381455dd5b4def4a1154ecf7df3bc937dbd3772"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0ea2dd6fd6548204f49e9139789141bb8138a5e67ea1e3b18d5cda0474704e6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "926c128e61c5c464d7517039e93d5f34670e63350f8f62d9edd2c70e1a870230"
    sha256 cellar: :any_skip_relocation, ventura:       "cfaf56b0ade925a990e1365f08a7fb6bd1fbb72d3b21f3f707c0f5c7ef1e31b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bb6be09826e5f76aa3d812c8f28ba7e68f603ad3694a1088b6c2b3d46cca3af"
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
