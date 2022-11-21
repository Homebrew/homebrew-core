class Kustomizer < Formula
  desc "Package manager for distributing Kubernetes configuration as OCI artifacts"
  homepage "https://github.com/stefanprodan/kustomizer"
  url "https://github.com/stefanprodan/kustomizer/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "5609d9d1424622f4dfa9b074a010cbedb04dd2ce916c5237fe997eb3cc2ab3eb"
  license "Apache-2.0"
  head "https://github.com/stefanprodan/kustomizer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bbe2b710747552f90907da4d1b68087e6b833613a30905888e39a8bb3cf86573"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c2eb17bda0c54419dfa9c368179c8c0dafe4be905f6298c19a244004ab163c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32ab4254bd7eb71b8e20c1cc6e111ef00bea41a339c04d6bebd146ffc0014cd1"
    sha256 cellar: :any_skip_relocation, monterey:       "10c018605e83c667479b22a4f32f8b4e0fcbfbffd16242094e7c76b7c3c4d37d"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c0793b103efcd2f999efd44c7242a7895350e3b9949fd0b7ad9c52548df708e"
    sha256 cellar: :any_skip_relocation, catalina:       "e8477174ab0e0dadb5bde2776351e05e0d495ecb8728b391a103f2cbcf7d45f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "108caba819fb38007b0e2c487acfcd2a9fda05e78531af1f42965e366894bc2b"
  end

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
