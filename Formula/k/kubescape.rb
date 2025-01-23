class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v3.0.24.tar.gz"
  sha256 "76a71014e6f9fe8884e890f2bcdacc196a5fc72d180821f59425eb07bc37fe24"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30cfbe0ec7907e1c967f0826a58b9e268eacba92ef80c0d5e411c401a1bf8b60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fcf2b8ab157c7b0338fd46c517a132fd4e784350490f600d2f4d33b2f2e75c15"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6450cea0ffac51716cc2c071b83e94f357fd2727658509bd85255c9f705d54f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8adb000dd6793a9b00093941111bc3e7090b7954c83438efb18290236b65920b"
    sha256 cellar: :any_skip_relocation, ventura:       "7df08865b659e987c1260c91272714d33780f34e01de99813a923bd546e6a4d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce6d8a6e61e59253457d4f10eaa5799605c9e6aa0adf0ca7aa085c44b22998f8"
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
