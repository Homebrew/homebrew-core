class Kapp < Formula
  desc "CLI tool for Kubernetes users to group and manage bulk resources"
  homepage "https://carvel.dev/kapp/"
  url "https://github.com/carvel-dev/kapp/archive/refs/tags/v0.66.2.tar.gz"
  sha256 "8983b3f80312e65b97d909d426fea1536666e1012e174df0d83be114d59c01c7"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kapp.git", branch: "develop"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2e4304fac3412edbd726b88da1ffe235ccb8023f2ba969c86ae1d50ec190875b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9e2e61602002e6b8c02390f4a5529ac61c2f9da60083d9274784f826713d8ff9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4023825f835a3bc5ee447e6b1f3380758f2dd018a9a39d414a9fbd2fe6689d74"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "301ef242be23613f17c13fcb8eb15de9121fd19974c0ea56c146d2927c774acf"
    sha256 cellar: :any,                 x86_64_linux:      "b15370e2bfd63dc3a5997cb326b6fbe33b6f6feacba7d3ba5d21a7c7ce9e74e0"
  end

  depends_on "go" => :build

  deny_network_access!

  def install
    ldflags = "-X carvel.dev/kapp/pkg/kapp/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kapp"

    generate_completions_from_executable(bin/"kapp", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kapp version")

    output = shell_output("#{bin}/kapp list 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    output = shell_output("#{bin}/kapp deploy-config")
    assert_match "Copy over all metadata (with resourceVersion, etc.)", output
  end
end
