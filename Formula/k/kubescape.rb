class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://kubescape.io"
  # Use GitHub repo URL because the version for the build will be automatically fetched from git.
  url "https://github.com/kubescape/kubescape.git",
      tag:      "v4.0.10",
      revision: "f956507357091c3806777fe13ddf5e65efe36e44"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ddc34f9c6c5eed6eaa5a295c78a9f8cb1f260820d40e79c1296f66ef5fb02a72"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c204eda9c4e9436f379e492312944ff6026bad60b62a657004fa656725af6a92"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b030778f40263202311e7dd054d99722e89420caaff2f90b0e267df522ed45c"
    sha256 cellar: :any_skip_relocation, sonoma:        "244dbcd0dea23a8fc19b318b626c8df655e9ab8247f7ccd0932c667a30bd2659"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "66f348cdc20b3f769f321a48600d5a49d7142e5b4a5a674df6c757a7d8fd2194"
    sha256 cellar: :any,                 x86_64_linux:  "2b929a03c8ac058303115cdb7f235d93b30526ce121a552b3b69f7b090171de1"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"kubescape", shell_parameter_format: :cobra)
  end

  test do
    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "Failed resources by severity:", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
