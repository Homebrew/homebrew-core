class Kwctl < Formula
  desc "CLI tool for the Kubewarden policy engine for Kubernetes"
  homepage "https://www.kubewarden.io/"
  url "https://github.com/kubewarden/kwctl/archive/refs/tags/v1.22.1.tar.gz"
  sha256 "105b1856347e3e602b522aa43c521d8dbf4bff581fa3536bd3fab2dfe3883561"
  license "Apache-2.0"
  head "https://github.com/kubewarden/kwctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8e7cbcb696deac5c921a9d98b9cbc4858de3d43b0ba15a5e9519ad7251337db9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "050badeeb65b5b1b5817bc01c375dc3306a51d9b9936b3206f649b0827fb401d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58bcad45346e107784d5169bd00154d80f0d251487c071181900cb1453cdb131"
    sha256 cellar: :any_skip_relocation, sonoma:        "fda8a8dbaee14367fd8c513ab8471a3a4d5ed7bd03f65a08959e54b83bf5d51b"
    sha256 cellar: :any_skip_relocation, ventura:       "9c95c58afb172a685155591a6e8effc7d5a6b88189758c70c56e818470f15f0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "984093af29eba1bb7eebb21e32f280c5d7af3862f7308ea45638cf135b2a5579"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkgconf" => :build
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
