class Kumactl < Formula
  desc "Kuma control plane command-line utility"
  homepage "https://kuma.io/"
  url "https://github.com/kumahq/kuma/archive/refs/tags/v2.13.5.tar.gz"
  sha256 "f3a1f389917f3635db3843479421bd3a33d52cd965fe59f2d9975b06c4dafe00"
  license "Apache-2.0"
  head "https://github.com/kumahq/kuma.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3bb10bbf1bd94ab18005a3c2e33a09a30c2ffb61762d7a570711bd89134d900"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74b76c98a649e6d1f72f69fe22d9fd1157c356d1da29e994ec255b57b05a4419"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c99bf5bd95be24a3523dd45846428709d88edf88dddf2d18c4dd7234b43da721"
    sha256 cellar: :any_skip_relocation, sonoma:        "592a5afe00a1ff9b20c24dfd162dedd35c3378cb0b75eddd5658fefb9dcde7d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc20de026a9f29345f60474cdb060d866f96a0a187153978f98463c9877d35a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77f989ea5e0930b31a8541e164481f6e8c64ac93070bf4c0cd879dd4cddb7ce4"
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
