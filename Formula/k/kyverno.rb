class Kyverno < Formula
  desc "Kubernetes Native Policy Management"
  homepage "https://kyverno.io/"
  url "https://github.com/kyverno/kyverno/archive/refs/tags/v1.13.2.tar.gz"
  sha256 "6f5407784bf2c9e8934f67c2b8836a072013078f0f7bed496cf657d5157a8ae2"
  license "Apache-2.0"
  head "https://github.com/kyverno/kyverno.git", branch: "main"

  # This regex is intended to match Kyverno version tags (e.g., `v1.2.3`) and
  # omit unrelated tags (e.g., `helm-chart-v2.0.3`).
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ec238513f165f70eee6719cf763393f90e1ae4d3fd2e4392609a6f53a06a5b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1ccbe898f68b7acd91ad8e444f9d5903b89cea3fc0f41195f709b0b3db8425dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ed57ba924f2ed1b771e6b8e1ec7a2c539fd458e44b7335fbce01f23fbe4dfbde"
    sha256 cellar: :any_skip_relocation, sonoma:        "516404034e805a605c589f462f11b99b0b27c44fcee45271cffb3b428aeca30e"
    sha256 cellar: :any_skip_relocation, ventura:       "4726d55cecd2a7c616eb00ffb1900b73a93392e3a37900b9f9a6612237828ef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7209c5d2d23a9e94006924e99479f449079777ed43e27cf5bf1cf1d005344355"
  end

  depends_on "go" => :build

  def install
    project = "github.com/kyverno/kyverno"
    ldflags = %W[
      -s -w
      -X #{project}/pkg/version.BuildVersion=#{version}
      -X #{project}/pkg/version.BuildHash=
      -X #{project}/pkg/version.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/cli/kubectl-kyverno"

    generate_completions_from_executable(bin/"kyverno", "completion")
  end

  test do
    assert_match "No test yamls available", shell_output("#{bin}/kyverno test .")

    assert_match version.to_s, shell_output("#{bin}/kyverno version")
  end
end
