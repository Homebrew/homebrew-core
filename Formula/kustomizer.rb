class Kustomizer < Formula
  desc "Package manager for distributing Kubernetes configuration as OCI artifacts"
  homepage "https://github.com/stefanprodan/kustomizer"
  url "https://github.com/stefanprodan/kustomizer/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "5609d9d1424622f4dfa9b074a010cbedb04dd2ce916c5237fe997eb3cc2ab3eb"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/kustomizer.git", branch: "main"

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=#{version}"), "./cmd/kustomizer"

    generate_completions_from_executable(bin/"kustomizer", "completion")
  end

  test do
    system bin/"kustomizer", "config", "init"
    assert_match "apiVersion: kustomizer.dev/v1", (testpath/".kustomizer/config").read

    output = shell_output("#{bin}/kustomizer list artifact 2>&1", 1)
    assert_match "you must specify an artifact repository e.g. 'oci://docker.io/user/repo'", output
  end
end
