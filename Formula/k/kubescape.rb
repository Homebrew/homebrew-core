class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.7.tar.gz"
  sha256 "1e59ab2c3dabb544473b7fb78b83c3dcf4bc77851eda3d5fbf0b9607ba99c9c3"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f6d4593b7f2f2b34008519ac21ab8fae88af6d9af46d5a7d38e7f17cec95914f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b85dbb99c0dbe3d742ff91f2f2194481ed8da36fac04db93d1a701f419837f4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a5bf6f63d90943ed0636bfc96a6d25f30cd00f361d423bd1863f45ff490a95a"
    sha256 cellar: :any_skip_relocation, sonoma:         "b8555095fc544e8db4839c353f3f7f420ba29ea4cacebd8c3872f803252d26ee"
    sha256 cellar: :any_skip_relocation, ventura:        "f854645a3ee0053fb595b8f4b6de0b4709e7e775bc605d3ad2a9cc804d4d6fcf"
    sha256 cellar: :any_skip_relocation, monterey:       "8fd68a948abf58e4f34220be22c29168dbad1d40745e93c57da1695611e6ea0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb06bcd3b37f0141d7ba5ec7e2e525f3a2a5884a8c2cef8e69823f28853bb7ee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubescape/kubescape/v3/core/cautils.BuildNumber=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubescape", "completion")
  end

  test do
    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
