class Kompose < Formula
  desc "Tool to move from `docker-compose` to Kubernetes"
  homepage "https://kompose.io/"
  url "https://github.com/kubernetes/kompose/archive/v1.30.0.tar.gz"
  sha256 "39786782c38a4d4c41f0f1c6dd441394e230bdcd10b64a66501cf72b9405ddcf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f471417595398f4064e6d93777eed6c307e7e84adacce916016f21eaa04e179"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f471417595398f4064e6d93777eed6c307e7e84adacce916016f21eaa04e179"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f471417595398f4064e6d93777eed6c307e7e84adacce916016f21eaa04e179"
    sha256 cellar: :any_skip_relocation, ventura:        "2e7f236b87e494cefae14fe2bfe91ca812b47e45396f4248cb9c8f8d5740b664"
    sha256 cellar: :any_skip_relocation, monterey:       "2e7f236b87e494cefae14fe2bfe91ca812b47e45396f4248cb9c8f8d5740b664"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e7f236b87e494cefae14fe2bfe91ca812b47e45396f4248cb9c8f8d5740b664"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41a8d654edf6864f1fc7cbffbc0b876316637e2ff58874dbc57bae378e9aa5c5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"kompose", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kompose version")
  end
end
