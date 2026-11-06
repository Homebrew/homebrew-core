class Istioctl < Formula
  desc "Istio configuration command-line utility"
  homepage "https://istio.io/"
  url "https://github.com/istio/istio/archive/refs/tags/1.31.4.tar.gz"
  sha256 "32f917c19d9510b33568979a49de05b4ac8e26ca4e14484450bcc007e2c4c575"
  license "Apache-2.0"
  head "https://github.com/istio/istio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fda577e32dfde10d22415c0bf3fa14b7ecda2dd6c790933c8ee4953bab6df558"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1a17a15e7580607399f966bd4b0847cd4be31f98e81e8ddf283feeff2ce48abb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2115601d5e9d4d668aa9effd498dcb9f42548e9b1f68c331a9e6bdaa15fb4e7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b04915622a0408113917fdbf31ad1461de842f78fc5f25cb5b4f022235043ff0"
    sha256 cellar: :any,                 x86_64_linux:      "de2cd20c21094995fe7d98ce252da0adee306e6e4347ca0ac4616579365a2354"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X istio.io/istio/pkg/version.buildVersion=#{version}
      -X istio.io/istio/pkg/version.buildGitRevision=#{tap.user}
      -X istio.io/istio/pkg/version.buildStatus=#{tap.user}
      -X istio.io/istio/pkg/version.buildTag=#{version}
      -X istio.io/istio/pkg/version.buildHub=docker.io/istio
    ]
    system "go", "build", *std_go_args(ldflags:), "./istioctl/cmd/istioctl"

    generate_completions_from_executable(bin/"istioctl", shell_parameter_format: :cobra)
    system bin/"istioctl", "collateral", "--man"
    man1.install Dir["*.1"]
  end

  test do
    assert_equal "client version: #{version}", shell_output("#{bin}/istioctl version --remote=false").strip
  end
end
