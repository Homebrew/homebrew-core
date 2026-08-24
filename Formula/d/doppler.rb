class Doppler < Formula
  desc "CLI for interacting with Doppler secrets and configuration"
  homepage "https://docs.doppler.com/docs"
  url "https://github.com/DopplerHQ/cli/archive/refs/tags/3.76.5.tar.gz"
  sha256 "e354474b8377c4deb91e70e2d8526fa245278e008d0ccd08b9df7c2ba625cdfb"
  license "Apache-2.0"
  head "https://github.com/DopplerHQ/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "711ec548468e998d042ef311c09a77e68b81781019e8b629001320be7533b79d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "711ec548468e998d042ef311c09a77e68b81781019e8b629001320be7533b79d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "711ec548468e998d042ef311c09a77e68b81781019e8b629001320be7533b79d"
    sha256 cellar: :any_skip_relocation, sonoma:        "aa1e6d7d698ec03c5c901943c7e467ab958e9c3e243107f9b09ab3f359774e17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a65e099533c5692886415a249d3d864ec9099763790a2b5960fd5b6a79f1952"
    sha256 cellar: :any,                 x86_64_linux:  "55948e3cf06dfc95c4370a2166b2046c1fd7225102846bb7088a1efe90fb3ae7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/DopplerHQ/cli/pkg/version.ProgramVersion=dev-#{version}]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"doppler", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/doppler --version")

    output = shell_output("#{bin}/doppler setup 2>&1", 1)
    assert_match "Doppler Error: you must provide a token", output
  end
end
