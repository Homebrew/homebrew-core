class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.25.0.tar.gz"
  sha256 "bcc1eb12b77d50c059353e6a78d7b4d7965cebd20bb7e6d69c7419ea1922e7d6"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "306ff1c2e1386cc48ff5569a1a9f7803348cfd9928c75868b4cbc1600c402f88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4aa9af4a64641e86d1a5a3054b39fc609dff1824e6866bb367baa26fce56608b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5679c39c525e4f5c909741aba6645e4cc573bc617b535bebe27e937c6ef7b414"
    sha256 cellar: :any_skip_relocation, sonoma:        "f2b17fbe3cdebb992fae1602654fccfff5173ea9d7bc66a029103a7ca4dd806b"
    sha256 cellar: :any_skip_relocation, ventura:       "bd0824dc4e1d600722945fbff47277802af5ffffa4835ee752d341e2df0939f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "23cbc4c5f71c6e9c8978e402c4f6e909361fd8698138c82e0a527348770331e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c49165293a7977e3930a5f68832b45a212eba9b94cd3215f9af3d1fab98dde89"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"kwctl", "completions", "--shell")
  end

  test do
    test_policy = "ghcr.io/kubewarden/policies/safe-labels:v0.1.7"
    assert_equal "kwctl #{version}", shell_output("#{bin}/kwctl --version").strip.split("\n")[0]
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
