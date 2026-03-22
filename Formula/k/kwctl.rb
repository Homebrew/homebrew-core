class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kubewarden-controller/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "8bdc59d34dcc2b94f9c82b8996c9735b58733b7f279cfefebf3be50074dd2c85"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kubewarden-controller.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b753565e38474273b4df3e1411ee2101e82b12dfe42113471508bc7adb0b104e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c0e310ff186f7c701fc56b164242004e537552213dc488cd20a7e66de6fd763"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0720b88636645c4c4451bf9ce8ecd43d7f130f3b507d19fc2368f43751fa84a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0b3a42bc40f2fb7146f3ad18f7d426b6880bd7f7acff86571c5613a0ecbef21"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "609fc9b73e6c5c135e96d235b74911fb8839bdeb2a092b50a80e3b4da395d095"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c88e7a6712ca927f36457bdc1e681d89fd25ac09002a5e145f3060b9ca1c8dca"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/kwctl")

    generate_completions_from_executable(bin/"kwctl", "completions", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kwctl --version")

    test_policy = "ghcr.io/kubewarden/policies/safe-labels:v0.1.7"
    system bin/"kwctl", "pull", test_policy
    assert_match test_policy, shell_output("#{bin}/kwctl policies")

    (testpath/"ingress.json").write <<~JSON
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
    JSON
    (testpath/"policy-settings.json").write <<~JSON
      {
        "denied_labels": [
          "owner"
        ]
      }
    JSON

    output = shell_output(
      "#{bin}/kwctl run " \
      "registry://#{test_policy} " \
      "--request-path #{testpath}/ingress.json " \
      "--settings-path #{testpath}/policy-settings.json",
    )
    assert_match "The following labels are denied: owner", output
  end
end
