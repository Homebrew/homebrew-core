class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "258c5d3b45926b3ff48b610a41ea7941f1a681770ae57975abf428c5793b2e7f"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e5fa9581178e52275228c8544c36b327ca71cabf3d5d67e42055ff53722ed654"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fc34c365d71ba3fd9335e436c23e3097d2744d98beda132df5c9aec572d702f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c3a97cf4efcc12d13adbc996f6b753816b2ed83c867de5cb3496cb13f596817"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd713de48ad28c782c75877cb1f90a4c7d5973dca74a9ba0f20a383fb50f3383"
    sha256 cellar: :any_skip_relocation, ventura:        "ee1ea11f7b59e43d17853851cdf0f937dc5dd207ced510ae27873a4a78fd601e"
    sha256 cellar: :any_skip_relocation, monterey:       "46833d92b281216b7d62d88c3e149501a2dc569cce3f26751e86eb485e9629c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9fef0c916cd08f4dd863ae14e9b77bf2e2f3ad79e87ce3ba166ab1649498b75"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"kwctl", "completions", "--shell")
  end

  test do
    test_policy = "ghcr.io/kubewarden/policies/safe-labels:v0.1.7"
    assert_equal "kwctl #{version}", shell_output("#{bin}/kwctl --version").strip.split("\n")[0]
    system bin/"kwctl", "pull", test_policy
    assert_match test_policy, shell_output("#{bin}/kwctl policies")

    (testpath/"ingress.json").write <<~EOS
      {
        "uid": "1299d386-525b-4032-98ae-1949f69f9cfc",
        "kind": {
          "group": "networking.k8s.io",
          "kind": "Ingress",
          "version": "v1"
        },
        "resource": {
          "group": "networking.k8s.io",
          "version": "v1",
          "resource": "ingresses"
        },
        "name": "foobar",
        "operation": "CREATE",
        "userInfo": {
          "username": "kubernetes-admin",
          "groups": [
            "system:masters",
            "system:authenticated"
          ]
        },
        "object": {
          "apiVersion": "networking.k8s.io/v1",
          "kind": "Ingress",
          "metadata": {
            "name": "tls-example-ingress",
            "labels": {
              "owner": "team"
            }
          },
          "spec": {
          }
        }
      }
    EOS
    (testpath/"policy-settings.json").write <<~EOS
      {
        "denied_labels": [
          "owner"
        ]
      }
    EOS

    output = shell_output(
      "#{bin}/kwctl run " \
      "registry://#{test_policy} " \
      "--request-path #{testpath}/ingress.json " \
      "--settings-path #{testpath}/policy-settings.json",
    )
    assert_match "The following labels are denied: owner", output
  end
end
