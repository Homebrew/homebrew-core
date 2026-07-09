class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "66a2713459122b5c0450c4f410fb47f44e1ffad8aefc1e063a841721f820a682"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6332966b6d678046ca2d200119c0ff0770978492b958cc0291f49a3701c0b56"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c2ea4866beb9d2e5a7f87e58ba731f833698189742e077238c16aa41ac0ecbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d54984d8dc87fae602a3e6f3c9d656e8173ceb7ce1fe750e8e635edb7094e96"
    sha256 cellar: :any_skip_relocation, sonoma:        "ade9a9179ed6c4ddfb254f13a2f7ae30c3e3a9d69a3b1433028ec1d7e40b0765"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c35994613bcdf93882e0ea41a4b18bfe537a66c58413071a555ee2468bd4898"
    sha256 cellar: :any,                 x86_64_linux:  "cf55053fa5c58e41934a211ab19f114b85d046783c6c174afba2168ea890aa6c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kumahq/kuma/v2/pkg/version.version=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.gitTag=#{version}
      -X github.com/kumahq/kuma/v2/pkg/version.buildDate=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args(ldflags:), "./app/kumactl"

    generate_completions_from_executable(bin/"kumactl", shell_parameter_format: :cobra)
  end

  test do
    assert_match "Management tool for Kuma.", shell_output(bin/"kumactl")
    assert_match version.to_s, shell_output("#{bin}/kumactl version 2>&1")

    touch testpath/"config.yml"
    assert_match "Error: no resource(s) passed to apply",
    shell_output("#{bin}/kumactl apply -f config.yml 2>&1", 1)
  end
end
