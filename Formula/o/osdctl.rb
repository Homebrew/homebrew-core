class Osdctl < Formula
  desc "CLI tool for managed OpenShift clusters"
  homepage "https://github.com/openshift/osdctl"
  url "https://github.com/openshift/osdctl/archive/refs/tags/v0.63.0.tar.gz"
  sha256 "1be4fb3e62e54c10977da04e308c29e7794c76f67f45186f0c9f4ea790efeb06"
  license "Apache-2.0"
  head "https://github.com/openshift/osdctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "edd8a36a7e57b5d6d82add3de2133de3fcb991dfc29e79595d4cc5a4b72631ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "edd8a36a7e57b5d6d82add3de2133de3fcb991dfc29e79595d4cc5a4b72631ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edd8a36a7e57b5d6d82add3de2133de3fcb991dfc29e79595d4cc5a4b72631ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "26fbb649281b6e1f16a71003a6b0493c50571b87f71ff4d926566837d949f9ec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f79eae49828f2788a83d3d66dc8d26e8e3a1a538500be5a221035ff83747f0b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e24723141428cbeabb66aeb67bb1e5b9c79dad54da8b367d2e2498e6e60b207"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ENV["GOFLAGS"] = "-mod=readonly"

    ldflags = %W[
      -X github.com/openshift/osdctl/pkg/utils.Version=#{version}
      -X github.com/openshift/osdctl/pkg/utils.InstallMethod=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"osdctl", "--skip-version-check", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osdctl version")

    assert_match 'Error: required flag(s) "cluster-id" not set',
      shell_output("#{bin}/osdctl --skip-version-check cluster context 2>&1", 1)
  end
end
