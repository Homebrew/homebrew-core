class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/v2.13.8.tar.gz"
  sha256 "1a3d8d496c78a533fa491cbc7bcb2e92803d294e19defbe334f2d819cac7c44b"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9ba00b9bada5644051a25b379e571736c20c06b37516bcb91eb449d1c453cb3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b384296b8a750db1e666160e6bbee2d066e1ee2dfbc78fe0f4a5ec9612bb1f73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de66100cfa7f129678710fdc1a47de01a9838de91e279dc6614ee8dad98a7109"
    sha256 cellar: :any_skip_relocation, sonoma:        "1890e3fc3139e63570bb25f8ec67d4b77d9ad2c4ed47a0b68f1226c2c460a129"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "398edd94a19d6c66e791bb3e7e8b2d027a6a37a2951e820400fabdd345f750c6"
    sha256 cellar: :any,                 x86_64_linux:  "7e065a4ea020fd577fb98bba41c628b44c55264fa0a3bec41e49c490e6157bff"
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
