class Epinio < Formula
  desc "CLI for Epinio, the Application Development Engine for Kubernetes"
  homepage "https://epinio.io/"
  url "https://github.com/epinio/epinio/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "b8dd204152e1e632215090c2304aef5655d9e7ed091b90bb103ff277ba9452dd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1a0b39fbbbf0eeae4cce02508aa0d25f0c8781d62bbf9a868831de193155318"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "def811800091e793fef8bc5270e0ccebc46a6f5a0a8c2a7b9f64512b55ab53c7"
    sha256 cellar: :any_skip_relocation, monterey:       "78cfbd72eede33d27cff27fcd3d014b8fb125cc04057e3907460fe7c14ccfeb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "a72d48f4c3a65867a2b727c792ef8fd49df77c8dc428e7b133fa82817d83ae23"
    sha256 cellar: :any_skip_relocation, catalina:       "29bfae0c6f173fdbd5381a139226eea74f5851e114cd472078424f11a3412ed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a179d0a201f2076fa17ab3a0f3f2d67bd79c4d811e3e253c3c1c9acad998f9a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/epinio/epinio/internal/version.Version=#{version}")
  end

  test do
    output = shell_output("#{bin}/epinio version 2>&1")
    assert_match "Epinio Version: #{version}", output

    output = shell_output("#{bin}/epinio settings update-ca 2>&1")
    assert_match "failed to get kube config", output
    assert_match "no configuration has been provided", output
  end
end
